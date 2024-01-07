import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_image.g.dart';

@JsonSerializable()
@HiveType(typeId: 123484)
class ProfileImage extends Equatable {
  @JsonKey(defaultValue: '')
  @HiveField(0, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  @HiveField(1, defaultValue: '')
  final String imageLink;

  @JsonKey(defaultValue: '')
  @HiveField(2, defaultValue: '')
  final String storageUuid;

  const ProfileImage({
    required this.id,
    required this.imageLink,
    required this.storageUuid,
  });

  const ProfileImage.empty()
      : this.id = '',
        this.imageLink = '',
        this.storageUuid = '';

  factory ProfileImage.fromJson(Map<String, dynamic> json) =>
      _$ProfileImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileImageToJson(this);

  @override
  List<Object?> get props => [id, imageLink, storageUuid];

  bool isEmpty() {
    return this == const ProfileImage.empty();
  }
}
