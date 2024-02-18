// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_profile_image_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProfileImageDto _$UpdateProfileImageDtoFromJson(
        Map<String, dynamic> json) =>
    UpdateProfileImageDto(
      imageLink: json['imageLink'] as String? ?? '',
      storageUuid: json['storageUuid'] as String? ?? '',
    );

Map<String, dynamic> _$UpdateProfileImageDtoToJson(
        UpdateProfileImageDto instance) =>
    <String, dynamic>{
      'imageLink': instance.imageLink,
      'storageUuid': instance.storageUuid,
    };
