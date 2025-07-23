import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  @JsonKey(fromJson: _idFromJson, toJson: _idToJson)
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? token;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.token,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  // Convenience getters
  String get userId => id;
  String? get profileImage => photoUrl;

  // Helper methods for id conversion
  static String _idFromJson(dynamic value) {
    if (value is int) {
      return value.toString();
    } else if (value is String) {
      return value;
    } else {
      return value?.toString() ?? '';
    }
  }

  static String _idToJson(String id) => id;
}
