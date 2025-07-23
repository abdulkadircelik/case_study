// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_photo_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadPhotoResponseModel _$UploadPhotoResponseModelFromJson(
        Map<String, dynamic> json) =>
    UploadPhotoResponseModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String,
    );

Map<String, dynamic> _$UploadPhotoResponseModelToJson(
        UploadPhotoResponseModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
    };
