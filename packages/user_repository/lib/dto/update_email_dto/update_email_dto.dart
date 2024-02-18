import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_email_dto.g.dart';

@JsonSerializable()
class UpdateEmailDto extends Equatable {
  @JsonKey(defaultValue: '')
  final String emailAddress;

  const UpdateEmailDto({
    required this.emailAddress,
  });

  factory UpdateEmailDto.empty() => UpdateEmailDto(
    emailAddress: '',
  );

  factory UpdateEmailDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateEmailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateEmailDtoToJson(this);

  @override
  List<Object?> get props => [emailAddress];
}
