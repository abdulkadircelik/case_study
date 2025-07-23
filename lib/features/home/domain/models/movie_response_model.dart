import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'movie_response_model.g.dart';

@JsonSerializable()
class MovieResponseModel {
  @JsonKey(name: 'data')
  final MovieDataModel data;

  MovieResponseModel({required this.data});

  factory MovieResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseModelToJson(this);
}

@JsonSerializable()
class MovieDataModel {
  @JsonKey(name: 'movies')
  final List<MovieModel> movies;

  MovieDataModel({required this.movies});

  factory MovieDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDataModelToJson(this);
}
