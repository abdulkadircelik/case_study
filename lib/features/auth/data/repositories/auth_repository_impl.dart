import 'package:dio/dio.dart';
import 'dart:io';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';
import '../../domain/models/register_request_model.dart';
import '../../domain/models/register_response_model.dart';
import '../../domain/models/upload_photo_response_model.dart';
import '../services/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiService.login(request);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _apiService.register(request);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }

  @override
  Future<UploadPhotoResponseModel> uploadPhoto(File file) async {
    try {
      print('Upload Photo File: ${file.path}');
      final response = await _apiService.uploadPhoto(file);
      print('Upload Photo Response: ${response.data.toJson()}');
      return response.data;
    } on DioException catch (e) {
      print('Upload Photo DioError: ${e.response?.data}');
      print('Upload Photo Status Code: ${e.response?.statusCode}');
      throw _handleDioError(e);
    } catch (e) {
      print('Upload Photo Error: $e');
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
