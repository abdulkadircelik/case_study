import 'package:dio/dio.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/models/user_profile_model.dart';
import '../../../home/domain/models/movie_response_model.dart';
import '../../../home/domain/models/movie_model.dart';
import '../services/user_profile_api_service.dart';
import '../../../home/data/services/movie_api_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final UserProfileApiService _profileApiService;
  final MovieApiService _movieApiService;

  ProfileRepositoryImpl(this._profileApiService, this._movieApiService);

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await _profileApiService.getUserProfile();
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get user profile failed: $e');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _profileApiService.updateUserProfile(profileData);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Update user profile failed: $e');
    }
  }

  @override
  Future<UserProfileModel> uploadProfilePhoto(FormData photoData) async {
    try {
      final response = await _profileApiService.uploadProfilePhoto(photoData);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Upload profile photo failed: $e');
    }
  }

  @override
  Future<MovieResponseModel> getFavoriteMovies() async {
    try {
      final response = await _movieApiService.getFavoriteMovies();

      if (response is Map<String, dynamic>) {
        // API response formatı: {"response": {...}, "data": [...]}
        final data = response['data'];

        if (data is List<dynamic>) {
          // data alanı direkt liste
          final movies = data
              .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return MovieResponseModel(data: MovieDataModel(movies: movies));
        } else if (data is Map<String, dynamic>) {
          // data alanı map (mevcut format)
          return MovieResponseModel.fromJson(response);
        } else {
          throw Exception('Unexpected data format: ${data.runtimeType}');
        }
      } else if (response is List<dynamic>) {
        // Direkt liste formatı
        final movies = response
            .map((item) => MovieModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return MovieResponseModel(data: MovieDataModel(movies: movies));
      } else {
        throw Exception('Unexpected response format: ${response.runtimeType}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get favorite movies failed: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return Exception('HTTP $statusCode: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
