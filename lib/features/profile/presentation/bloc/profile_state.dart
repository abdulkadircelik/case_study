import 'package:equatable/equatable.dart';
import '../../domain/models/user_profile_model.dart';
import '../../../home/domain/models/movie_response_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel userProfile;
  final MovieResponseModel? favoriteMovies;

  const ProfileLoaded({required this.userProfile, this.favoriteMovies});

  @override
  List<Object?> get props => [userProfile, favoriteMovies];

  ProfileLoaded copyWith({
    UserProfileModel? userProfile,
    MovieResponseModel? favoriteMovies,
  }) {
    return ProfileLoaded(
      userProfile: userProfile ?? this.userProfile,
      favoriteMovies: favoriteMovies ?? this.favoriteMovies,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
