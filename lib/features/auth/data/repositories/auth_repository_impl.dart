import 'package:dio/dio.dart';
import 'dart:io';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';
import '../../domain/models/register_request_model.dart';
import '../../domain/models/register_response_model.dart';
import '../../domain/models/upload_photo_response_model.dart';
import '../services/auth_api_service.dart';
import '../../../../core/services/logger_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final LoggerService _logger;

  AuthRepositoryImpl(this._apiService, this._logger);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      _logger.info('Login attempt for: ${request.email}');
      final response = await _apiService.login(request);
      _logger.info('Login successful for: ${request.email}');
      return response.data;
    } on DioException catch (e) {
      _logger.error('Login failed for: ${request.email}', e);
      throw _handleDioError(e);
    } catch (e) {
      _logger.error('Login failed for: ${request.email}', e);
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      _logger.info('Register attempt for: ${request.email}');
      final response = await _apiService.register(request);
      _logger.info('Register successful for: ${request.email}');
      return response.data;
    } on DioException catch (e) {
      _logger.error('Register failed for: ${request.email}', e);
      throw _handleDioError(e);
    } catch (e) {
      _logger.error('Register failed for: ${request.email}', e);
      throw Exception('Register failed: $e');
    }
  }

  @override
  Future<UploadPhotoResponseModel> uploadPhoto(File file) async {
    try {
      _logger.info('Upload photo attempt for file: ${file.path}');
      final response = await _apiService.uploadPhoto(file);
      _logger.info('Upload photo successful for file: ${file.path}');
      return response.data;
    } on DioException catch (e) {
      _logger.error('Upload photo failed for file: ${file.path}', e);
      throw _handleDioError(e);
    } catch (e) {
      _logger.error('Upload photo failed for file: ${file.path}', e);
      throw Exception('Upload photo failed: $e');
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
