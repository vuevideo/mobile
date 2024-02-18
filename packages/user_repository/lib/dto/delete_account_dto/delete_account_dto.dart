import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_account_dto.g.dart';

@JsonSerializable()
class DeleteAccountDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String password;

  const DeleteAccountDto({
    required this.password,
  });

  factory DeleteAccountDto.empty() => DeleteAccountDto(
    password: '',
  );

  factory DeleteAccountDto.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountDtoToJson(this);

  @override
  List<Object?> get props => [password];
}
