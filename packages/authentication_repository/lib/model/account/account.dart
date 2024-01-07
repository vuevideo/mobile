import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:authentication_repository/model/model.dart';

part 'account.g.dart';

@JsonSerializable()
@HiveType(typeId: 549988)
class Account extends Equatable {
  @JsonKey(defaultValue: '')
  @HiveField(0, defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  @HiveField(1, defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  @HiveField(2, defaultValue: '')
  final String username;

  @HiveField(3, defaultValue: const ProfileImage.empty())
  final ProfileImage image;

  const Account({
    required this.id,
    required this.name,
    required this.username,
    required this.image,
  });

  const Account.empty()
      : this.id = '',
        this.name = '',
        this.username = '',
        this.image = const ProfileImage.empty();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  List<Object?> get props => [id, name, username];

  bool isEmpty() {
    return this == const Account.empty();
  }
}
