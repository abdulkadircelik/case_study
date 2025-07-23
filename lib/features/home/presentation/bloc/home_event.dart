import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadMovies extends HomeEvent {
  final bool refresh;

  const LoadMovies({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class LoadMoreMovies extends HomeEvent {}

class ToggleFavorite extends HomeEvent {
  final String movieId;

  const ToggleFavorite(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
