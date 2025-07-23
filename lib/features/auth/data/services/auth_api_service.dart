import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../domain/models/api_response_model.dart';
import '../../domain/models/login_request_model.dart';
import '../../domain/models/login_response_model.dart';
import '../../domain/models/register_request_model.dart';
import '../../domain/models/register_response_model.dart';
import '../../domain/models/upload_photo_response_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST('/user/login')
  Future<ApiResponseModel<LoginResponseModel>> login(
    @Body() LoginRequestModel request,
  );

  @POST('/user/register')
  Future<ApiResponseModel<RegisterResponseModel>> register(
    @Body() RegisterRequestModel request,
  );

  @POST('/user/upload_photo')
  @MultiPart()
  Future<ApiResponseModel<UploadPhotoResponseModel>> uploadPhoto(
    @Part(name: 'file') File file,
  );
}
