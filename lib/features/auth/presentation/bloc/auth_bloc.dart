import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';
import '../../../../core/services/storage_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthBloc({
    required AuthRepository authRepository,
    required StorageService storageService,
  }) : _authRepository = authRepository,
       _storageService = storageService,
       super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<UploadPhotoRequested>(_onUploadPhotoRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final loginResponse = await _authRepository.login(event.request);

      // Token'ı güvenli şekilde sakla
      await _storageService.saveToken(loginResponse.token);
      await _storageService.saveUserData(loginResponse.toJson().toString());

      final userModel = UserModel.fromLoginResponse(loginResponse);
      emit(AuthAuthenticated(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final registerResponse = await _authRepository.register(event.request);

      // Token'ı güvenli şekilde sakla
      await _storageService.saveToken(registerResponse.token);
      await _storageService.saveUserData(registerResponse.toJson().toString());

      final userModel = UserModel.fromLoginResponse(registerResponse);
      emit(AuthAuthenticated(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUploadPhotoRequested(
    UploadPhotoRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final uploadResponse = await _authRepository.uploadPhoto(event.file);

      // User data'yı güncelle
      final updatedUserData = {
        'id': uploadResponse.id,
        'name': uploadResponse.name,
        'email': uploadResponse.email,
        'photoUrl': uploadResponse.photoUrl,
      };
      await _storageService.saveUserData(updatedUserData.toString());

      // Mevcut user'ı güncelle
      final currentState = state;
      if (currentState is AuthAuthenticated) {
        final updatedUser = UserModel(
          id: uploadResponse.id,
          name: uploadResponse.name,
          email: uploadResponse.email,
          photoUrl: uploadResponse.photoUrl,
          token: currentState.user.token,
        );
        emit(AuthAuthenticated(updatedUser));
      } else {
        // Eğer AuthAuthenticated state'de değilse, login'e yönlendir
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _storageService.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final token = await _storageService.getToken();
      final userData = await _storageService.getUserData();

      if (token != null && userData != null) {
        // Token varsa kullanıcıyı authenticate et
        // TODO: Parse user data properly
        emit(
          AuthAuthenticated(
            UserModel(
              id: 'temp_id',
              name: 'User',
              email: 'user@example.com',
              photoUrl: '',
              token: token,
            ),
          ),
        );
      } else {
        // Token yoksa unauthenticated
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }
}
