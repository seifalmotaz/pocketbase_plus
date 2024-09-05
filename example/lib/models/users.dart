// Model for Collection users
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

enum GenderEnum {
  male,
  female,
}

final _genderEnumToMap = {
  GenderEnum.male: "male",
  GenderEnum.female: "female",
};
final _genderEnumFromMap = {
  "male": GenderEnum.male,
  "female": GenderEnum.female,
};

class UsersModel {
  // Fields
  final String id;
  static const String Id = 'id';

  final DateTime created;
  static const String Created = 'created';

  final DateTime updated;
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
    required this.id,
    required this.created,
    required this.updated,
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
      gender: _genderEnumFromMap[r.data['gender']]!,
      height: r.data['height'],
      age: r.data['age'],
      deletedAt: r.data['deleted_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'phone_number': phoneNumber,
      'gender': _genderEnumToMap[gender],
      'height': height,
      'age': age,
      'deleted_at': deletedAt,
    };
  }
}
