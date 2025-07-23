import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // LoginResponseModel'den UserModel'e dönüştürme
  factory UserModel.fromLoginResponse(dynamic response) {
    return UserModel(
      id: response.id,
      name: response.name,
      email: response.email,
      photoUrl: response.photoUrl,
      token: response.token,
    );
  }
}
