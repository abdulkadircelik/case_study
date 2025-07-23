import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

class ApiResponseModel<T> {
  final ResponseModel response;
  final T data;

  ApiResponseModel({required this.response, required this.data});

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      response: ResponseModel.fromJson(
        json['response'] as Map<String, dynamic>,
      ),
      data: fromJsonT(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {'response': response.toJson(), 'data': toJsonT(data)};
  }
}

@JsonSerializable()
class ResponseModel {
  final int code;
  final String message;

  ResponseModel({required this.code, required this.message});

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
