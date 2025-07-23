import 'package:dio/dio.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/models/movie_response_model.dart';
import '../services/movie_api_service.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieApiService _apiService;

  MovieRepositoryImpl(this._apiService);

  @override
  Future<MovieResponseModel> getMovies(int page) async {
    try {
      final response = await _apiService.getMovies(page);
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Get movies failed: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String movieId) async {
    try {
      // Mock API call
      await Future.delayed(const Duration(milliseconds: 500));
      // Simulate success
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Toggle favorite failed: $e');
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
