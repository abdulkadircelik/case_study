import 'dart:io';
import '../models/user_profile_model.dart';
import '../../../home/domain/models/movie_response_model.dart';

abstract class ProfileRepository {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(Map<String, dynamic> profileData);
  Future<UserProfileModel> uploadProfilePhoto(File photoFile);
  Future<MovieResponseModel> getFavoriteMovies();
}
