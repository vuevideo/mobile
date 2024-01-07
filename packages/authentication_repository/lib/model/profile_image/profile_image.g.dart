// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileImageAdapter extends TypeAdapter<ProfileImage> {
  @override
  final int typeId = 123484;

  @override
  ProfileImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileImage(
      id: fields[0] == null ? '' : fields[0] as String,
      imageLink: fields[1] == null ? '' : fields[1] as String,
      storageUuid: fields[2] == null ? '' : fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageLink)
      ..writeByte(2)
      ..write(obj.storageUuid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
