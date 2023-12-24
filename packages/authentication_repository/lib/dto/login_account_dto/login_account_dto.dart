import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_account_dto.g.dart';

@JsonSerializable()
class LoginAccountDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String emailAddress;

  @JsonKey(defaultValue: '')
  final String password;

  const LoginAccountDto({
    required this.emailAddress,
    required this.password,
  });

  factory LoginAccountDto.empty() => LoginAccountDto(
        emailAddress: '',
        password: '',
      );

  factory LoginAccountDto.fromJson(Map<String, dynamic> json) =>
      _$LoginAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginAccountDtoToJson(this);

  @override
  List<Object?> get props => [emailAddress, password];
}
