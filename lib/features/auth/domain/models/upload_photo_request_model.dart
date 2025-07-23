import 'package:json_annotation/json_annotation.dart';

part 'upload_photo_request_model.g.dart';

@JsonSerializable()
class UploadPhotoRequestModel {
  @JsonKey(name: 'photoUrl')
  final String photoUrl;

  UploadPhotoRequestModel({required this.photoUrl});

  factory UploadPhotoRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UploadPhotoRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadPhotoRequestModelToJson(this);
}
