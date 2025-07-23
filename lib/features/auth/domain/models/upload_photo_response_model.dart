import 'package:json_annotation/json_annotation.dart';

part 'upload_photo_response_model.g.dart';

@JsonSerializable()
class UploadPhotoResponseModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  UploadPhotoResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UploadPhotoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoResponseModelToJson(this);
}
