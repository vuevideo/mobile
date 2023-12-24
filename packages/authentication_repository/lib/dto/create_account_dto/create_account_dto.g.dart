// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAccountDto _$CreateAccountDtoFromJson(Map<String, dynamic> json) =>
    CreateAccountDto(
      emailAddress: json['emailAddress'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$CreateAccountDtoToJson(CreateAccountDto instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'username': instance.username,
      'password': instance.password,
      'name': instance.name,
    };
