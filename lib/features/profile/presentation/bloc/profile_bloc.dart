import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository,
      super(ProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LoadFavoriteMovies>(_onLoadFavoriteMovies);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UploadProfilePhoto>(_onUploadProfilePhoto);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final userProfile = await _profileRepository.getUserProfile();
      emit(ProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLoadFavoriteMovies(
    LoadFavoriteMovies event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final favoriteMovies = await _profileRepository.getFavoriteMovies();
        emit(currentState.copyWith(favoriteMovies: favoriteMovies));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final updatedProfile = await _profileRepository.updateUserProfile(
          event.profileData,
        );
        emit(currentState.copyWith(userProfile: updatedProfile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }

  Future<void> _onUploadProfilePhoto(
    UploadProfilePhoto event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      try {
        final updatedProfile = await _profileRepository.uploadProfilePhoto(
          event.photoData,
        );
        emit(currentState.copyWith(userProfile: updatedProfile));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    }
  }
}
