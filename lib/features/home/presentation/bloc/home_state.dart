import 'package:equatable/equatable.dart';
import '../../domain/models/movie_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieModel> movies;
  final bool hasNextPage;
  final int currentPage;

  const HomeLoaded({
    required this.movies,
    required this.hasNextPage,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [movies, hasNextPage, currentPage];

  HomeLoaded copyWith({
    List<MovieModel>? movies,
    bool? hasNextPage,
    int? currentPage,
  }) {
    return HomeLoaded(
      movies: movies ?? this.movies,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class HomeLoadingMore extends HomeState {
  final List<MovieModel> movies;
  final bool hasNextPage;
  final int currentPage;

  const HomeLoadingMore({
    required this.movies,
    required this.hasNextPage,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [movies, hasNextPage, currentPage];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
