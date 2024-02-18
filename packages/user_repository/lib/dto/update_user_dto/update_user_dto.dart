import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_user_dto.g.dart';

@JsonSerializable()
class UpdateUserDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String username;
  final String name;

  const UpdateUserDto({
    required this.username,
    required this.name,
  });

  factory UpdateUserDto.empty() => UpdateUserDto(
    username: '',
    name: '',
  );

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);

  @override
  List<Object?> get props => [username, name];
}
