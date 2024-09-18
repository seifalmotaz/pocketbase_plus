// This file is auto-generated. Do not modify manually.
// Model for collection users
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

enum GenderEnum {
  male("male"),
  female("female"),
  ;

  final String value;

  const GenderEnum(this.value);

  static GenderEnum fromValue(String value) {
    return GenderEnum.values.firstWhere(
      (enumValue) => enumValue.value == value,
      orElse: () => throw ArgumentError("Invalid value: $value"),
    );
  }
}

class UsersModel {
  // Fields
  final String? id;
  static const String Id = 'id';

  final DateTime? created;
  static const String Created = 'created';

  final DateTime? updated;
  static const String Updated = 'updated';

  final String? name;
  static const String Name = 'name';

  final dynamic avatar;
  static const String Avatar = 'avatar';

  final String? bio;
  static const String Bio = 'bio';

  final String phoneNumber;
  static const String PhoneNumber = 'phone_number';

  final GenderEnum gender;
  static const String Gender = 'gender';

  final num height;
  static const String Height = 'height';

  final num age;
  static const String Age = 'age';

  final DateTime? deletedAt;
  static const String DeletedAt = 'deleted_at';

  const UsersModel({
    this.id,
    this.created,
    this.updated,
    this.name,
    this.avatar,
    this.bio,
    required this.phoneNumber,
    required this.gender,
    required this.height,
    required this.age,
    this.deletedAt,
  });

  factory UsersModel.fromModel(RecordModel r) {
    return UsersModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      name: r.data['name'],
      avatar: r.data['avatar'],
      bio: r.data['bio'],
      phoneNumber: r.data['phone_number'],
      gender: GenderEnum.fromValue(r.data['gender']! as String),
      height: r.data['height'],
      age: r.data['age'],
      deletedAt: r.data['deleted_at'] != null
          ? DateTime.parse(r.data['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'phone_number': phoneNumber,
      'gender': gender.value,
      'height': height,
      'age': age,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
