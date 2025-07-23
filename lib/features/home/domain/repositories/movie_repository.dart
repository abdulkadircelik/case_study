import '../models/movie_response_model.dart';

abstract class MovieRepository {
  Future<MovieResponseModel> getMovies(int page);
  Future<void> toggleFavorite(String movieId);
  Future<MovieResponseModel> getFavoriteMovies();
}
