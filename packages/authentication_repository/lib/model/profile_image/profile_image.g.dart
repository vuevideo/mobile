// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileImage _$ProfileImageFromJson(Map<String, dynamic> json) => ProfileImage(
      id: json['id'] as String? ?? '',
      imageLink: json['imageLink'] as String? ?? '',
      storageUuid: json['storageUuid'] as String? ?? '',
    );

Map<String, dynamic> _$ProfileImageToJson(ProfileImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageLink': instance.imageLink,
      'storageUuid': instance.storageUuid,
    };
