import 'dart:ffi';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:const_date_time/const_date_time.dart';

part 'credentials.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Credentials extends Equatable {
  @JsonKey(defaultValue: '')
  @HiveField(0, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  @HiveField(1, defaultValue: '')
  final String emailAddress;

  @HiveField(2, defaultValue: const Account.empty())
  final Account account;

  @HiveField(3, defaultValue: const ConstDateTime(0))
  final DateTime createdAt;

  @HiveField(4, defaultValue: const ConstDateTime(0))
  final DateTime updatedAt;

  Credentials({
    required this.id,
    required this.emailAddress,
    this.account = const Account.empty(),
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
