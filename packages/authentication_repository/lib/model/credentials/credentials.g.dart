// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credentials _$CredentialsFromJson(Map<String, dynamic> json) => Credentials(
      id: json['id'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CredentialsToJson(Credentials instance) =>
    <String, dynamic>{
      'id': instance.id,
      'emailAddress': instance.emailAddress,
      'account': instance.account,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
