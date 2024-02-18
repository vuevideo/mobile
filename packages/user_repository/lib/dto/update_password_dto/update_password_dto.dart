import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_password_dto.g.dart';

@JsonSerializable()
class UpdatePasswordDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String oldPassword;

  @JsonKey(defaultValue: '')
  final String newPassword;

  const UpdatePasswordDto({
    required this.oldPassword,
    required this.newPassword,
  });

  factory UpdatePasswordDto.empty() => UpdatePasswordDto(
    oldPassword: '',
    newPassword: '',
  );

  factory UpdatePasswordDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatePasswordDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatePasswordDtoToJson(this);

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
