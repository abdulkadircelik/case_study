import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../domain/models/movie_response_model.dart';

part 'movie_api_service.g.dart';

@RestApi()
abstract class MovieApiService {
  factory MovieApiService(Dio dio, {String baseUrl}) = _MovieApiService;

  @GET('/movie/list')
  Future<MovieResponseModel> getMovies(@Query('page') int page);

  @POST('/movies/{id}/favorite')
  Future<void> toggleFavorite(@Path('id') String movieId);
}
