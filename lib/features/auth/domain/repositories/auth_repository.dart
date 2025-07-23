import 'dart:io';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';
import '../models/upload_photo_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<UploadPhotoResponseModel> uploadPhoto(File file);
}
