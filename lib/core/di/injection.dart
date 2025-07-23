import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../services/logger_service.dart';
import '../services/navigation_service.dart';
import '../services/storage_service.dart';
// import '../services/localization_service.dart';
import '../../features/auth/data/services/auth_api_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/services/movie_api_service.dart';
import '../../features/home/data/repositories/movie_repository_impl.dart';
import '../../features/home/domain/repositories/movie_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/profile/data/services/user_profile_api_service.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core Services
  getIt.registerSingleton<LoggerService>(LoggerService());
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<StorageService>(StorageService());
  // getIt.registerSingleton<LocalizationService>(
  //   LocalizationService(getIt<StorageService>()),
  // );

  // HTTP Client
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://caseapi.servicelabs.tech',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptor for authorization
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add authorization header if token exists
        final storageService = getIt<StorageService>();
        final token = await storageService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        getIt<LoggerService>().info('Request URL: ${options.uri}');
        getIt<LoggerService>().debug('Request Headers: ${options.headers}');
        getIt<LoggerService>().debug('Request Data: ${options.data}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        getIt<LoggerService>().info('Response Status: ${response.statusCode}');
        getIt<LoggerService>().debug('Response Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) async {
        getIt<LoggerService>().error(
          'Error Status: ${error.response?.statusCode}',
        );
        getIt<LoggerService>().error('Error Data: ${error.response?.data}');

        // Token refresh logic for 401 errors
        if (error.response?.statusCode == 401) {
          try {
            final storageService = getIt<StorageService>();
            final refreshToken = await storageService.getRefreshToken();

            if (refreshToken != null && refreshToken.isNotEmpty) {
              // Try to refresh token
              // Note: You'll need to implement the refresh token API call
              getIt<LoggerService>().info('Attempting token refresh');

              // For now, just clear the token and redirect to login
              await storageService.clearSecureStorage();
              getIt<LoggerService>().warning('Token expired, clearing storage');
            }
          } catch (refreshError) {
            getIt<LoggerService>().error('Token refresh failed', refreshError);
            await getIt<StorageService>().clearSecureStorage();
          }
        }

        handler.next(error);
      },
    ),
  );

  getIt.registerSingleton<Dio>(dio);

  // API Services
  getIt.registerSingleton<AuthApiService>(AuthApiService(dio));
  getIt.registerSingleton<MovieApiService>(MovieApiService(dio));
  getIt.registerSingleton<UserProfileApiService>(UserProfileApiService(dio));

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<AuthApiService>(), getIt<LoggerService>()),
  );
  getIt.registerSingleton<MovieRepository>(
    MovieRepositoryImpl(getIt<MovieApiService>(), getIt<LoggerService>()),
  );
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(
      getIt<UserProfileApiService>(),
      getIt<MovieApiService>(),
      getIt<LoggerService>(),
    ),
  );

  // Blocs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      storageService: getIt<StorageService>(),
    ),
  );
  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(movieRepository: getIt<MovieRepository>()),
  );
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(profileRepository: getIt<ProfileRepository>()),
  );
}
