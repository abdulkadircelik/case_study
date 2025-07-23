import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {
  const LoadUserProfile();
}

class LoadFavoriteMovies extends ProfileEvent {
  const LoadFavoriteMovies();
}

class UpdateUserProfile extends ProfileEvent {
  final Map<String, dynamic> profileData;

  const UpdateUserProfile(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

class UploadProfilePhoto extends ProfileEvent {
  final FormData photoData;

  const UploadProfilePhoto(this.photoData);

  @override
  List<Object?> get props => [photoData];
}
