import 'package:json_annotation/json_annotation.dart';
import 'user_profile_model.dart';

part 'user_profile_response_model.g.dart';

@JsonSerializable()
class UserProfileResponseModel {
  final ResponseModel response;
  final UserProfileModel data;

  UserProfileResponseModel({required this.response, required this.data});

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileResponseModelToJson(this);
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
