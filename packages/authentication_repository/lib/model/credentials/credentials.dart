import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/model/model.dart';
import 'package:const_date_time/const_date_time.dart';

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

  const Credentials.empty()
      : this.id = '',
        this.emailAddress = '',
        this.account = const Account.empty(),
        createdAt = const ConstDateTime(0),
        updatedAt = const ConstDateTime(0);

  factory Credentials.fromJson(Map<String, dynamic> json) =>
      _$CredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$CredentialsToJson(this);

  @override
  List<Object?> get props => [id, emailAddress];

  bool isEmpty() {
    return this == const Credentials.empty();
  }
}
