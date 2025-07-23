import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/movie_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieRepository _movieRepository;

  HomeBloc({required MovieRepository movieRepository})
    : _movieRepository = movieRepository,
      super(HomeInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<HomeState> emit) async {
    if (event.refresh) {
      emit(HomeLoading());
    }

    try {
      final response = await _movieRepository.getMovies(1);
      emit(
        HomeLoaded(
          movies: response.data.movies,
          hasNextPage: response.data.movies.length >= 5, // Assume 5 per page
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded && currentState.hasNextPage) {
      emit(
        HomeLoadingMore(
          movies: currentState.movies,
          hasNextPage: currentState.hasNextPage,
          currentPage: currentState.currentPage,
        ),
      );

      try {
        final response = await _movieRepository.getMovies(
          currentState.currentPage + 1,
        );

        final updatedMovies = [...currentState.movies, ...response.data.movies];
        emit(
          HomeLoaded(
            movies: updatedMovies,
            hasNextPage: response.data.movies.length >= 5, // Assume 5 per page
            currentPage: currentState.currentPage + 1,
          ),
        );
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      try {
        await _movieRepository.toggleFavorite(event.movieId);

        // Update UI immediately
        final updatedMovies = currentState.movies.map((movie) {
          if (movie.id == event.movieId) {
            return movie.copyWith(isFavorite: !movie.isFavorite);
          }
          return movie;
        }).toList();

        emit(
          HomeLoaded(
            movies: updatedMovies,
            hasNextPage: currentState.hasNextPage,
            currentPage: currentState.currentPage,
          ),
        );
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }
}
