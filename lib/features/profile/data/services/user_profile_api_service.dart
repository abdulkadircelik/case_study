import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../domain/models/user_profile_model.dart';
import '../../domain/models/user_profile_response_model.dart';

part 'user_profile_api_service.g.dart';

@RestApi()
abstract class UserProfileApiService {
  factory UserProfileApiService(Dio dio, {String baseUrl}) =
      _UserProfileApiService;

  @GET('/user/profile')
  Future<UserProfileResponseModel> getUserProfile();

  @PUT('/user/profile')
  Future<UserProfileResponseModel> updateUserProfile(
    @Body() Map<String, dynamic> profileData,
  );

  @POST('/user/upload_photo')
  @MultiPart()
  Future<UserProfileResponseModel> uploadProfilePhoto(
    @Part(name: 'file') File photo,
  );
}
