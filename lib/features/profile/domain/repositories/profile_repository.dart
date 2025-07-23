import 'package:dio/dio.dart';
import '../models/user_profile_model.dart';
import '../models/user_profile_response_model.dart';
import '../../../home/domain/models/movie_response_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> profileData);
  Future<UserProfileModel> uploadProfilePhoto(FormData photoData);
  Future<MovieResponseModel> getFavoriteMovies();
}
