import 'package:dio/dio.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/models/movie_response_model.dart';
import '../services/movie_api_service.dart';
import '../../../../core/services/logger_service.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieApiService _apiService;
  final LoggerService _logger;

  MovieRepositoryImpl(this._apiService, this._logger);

  @override
  Future<MovieResponseModel> getMovies(int page) async {
    try {
      _logger.info('Get movies attempt for page: $page');
      final response = await _apiService.getMovies(page);
      _logger.info('Get movies successful for page: $page');
      return response;
    } on DioException catch (e) {
      _logger.error('Get movies failed for page: $page', e);
      throw _handleDioError(e);
    } catch (e) {
      _logger.error('Get movies failed for page: $page', e);
      throw Exception('Get movies failed: $e');
    }
  }

  @override
  Future<void> toggleFavorite(String movieId) async {
    try {
      await _apiService.toggleFavorite(movieId);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Toggle favorite failed: $e');
    }
  }

  @override
  Future<MovieResponseModel> getFavoriteMovies() async {
    try {
      final response = await _apiService.getFavoriteMovies();
      return response;
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
