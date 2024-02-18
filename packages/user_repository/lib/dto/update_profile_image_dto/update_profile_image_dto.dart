import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_profile_image_dto.g.dart';

@JsonSerializable()
class UpdateProfileImageDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String imageLink;

  @JsonKey(defaultValue: '')
  final String storageUuid;

  const UpdateProfileImageDto({
    required this.imageLink,
    required this.storageUuid,
  });

  factory UpdateProfileImageDto.empty() => UpdateProfileImageDto(
    imageLink: '',
    storageUuid: '',
  );

  factory UpdateProfileImageDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileImageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileImageDtoToJson(this);

  @override
  List<Object?> get props => [imageLink, storageUuid];
}
