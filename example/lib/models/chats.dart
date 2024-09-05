// Model for Collection chats
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

class ChatsModel {
  // Fields
  final String id;
  static const String Id = 'id';

  final DateTime created;
  static const String Created = 'created';

  final DateTime updated;
  static const String Updated = 'updated';

  final dynamic user1;
  static const String User1 = 'user1';

  final dynamic user2;
  static const String User2 = 'user2';

  final DateTime? deletedAt;
  static const String DeletedAt = 'deleted_at';

  final bool? blocked;
  static const String Blocked = 'blocked';

  const ChatsModel({
    required this.id,
    required this.created,
    required this.updated,
    required this.user1,
    required this.user2,
    this.deletedAt,
    this.blocked,
  });

  factory ChatsModel.fromModel(RecordModel r) {
    return ChatsModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      user1: r.data['user1'],
      user2: r.data['user2'],
      deletedAt: r.data['deleted_at'],
      blocked: r.data['blocked'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user1': user1,
      'user2': user2,
      'deleted_at': deletedAt,
      'blocked': blocked,
    };
  }
}
