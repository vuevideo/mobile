import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/model/model.dart';

part 'credentials.g.dart';

@JsonSerializable()
class Credentials extends Equatable {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String emailAddress;

  final Account account;

  final DateTime createdAt;
  final DateTime updatedAt;

  Credentials({
    required this.id,
    required this.emailAddress,
    required this.account,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Credentials.empty() => Credentials(
        id: '',
        emailAddress: '',
        account: Account.empty(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);

  @override
  List<Object?> get props => [id, emailAddress];
}
