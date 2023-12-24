import 'package:json_annotation/json_annotation.dart';

part 'profile_image.g.dart';

@JsonSerializable()
class ProfileImage {

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String imageLink;

  @JsonKey(defaultValue: '')
  final String storageUuid;

  ProfileImage({
    required this.id,
    required this.imageLink,
    required this.storageUuid,
  });

  factory ProfileImage.empty() => ProfileImage(
    id: "",
    imageLink: "",
    storageUuid: "",
  );

  factory ProfileImage.fromJson(Map<String, dynamic> json) => _$ProfileImageFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileImageToJson(this);
}
