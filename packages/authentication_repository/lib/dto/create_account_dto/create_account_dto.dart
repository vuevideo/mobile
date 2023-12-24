import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_account_dto.g.dart';

@JsonSerializable()
class CreateAccountDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String emailAddress;

  @JsonKey(defaultValue: '')
  final String username;

  @JsonKey(defaultValue: '')
  final String password;

  @JsonKey(defaultValue: '')
  final String name;

  const CreateAccountDto({
    required this.emailAddress,
    required this.username,
    required this.password,
    required this.name,
  });

  factory CreateAccountDto.empty() => CreateAccountDto(
        emailAddress: '',
        username: '',
        password: '',
        name: '',
      );

  factory CreateAccountDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAccountDtoToJson(this);

  @override
  List<Object?> get props => [emailAddress, username, password, name];
}
