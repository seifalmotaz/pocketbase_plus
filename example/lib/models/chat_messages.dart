// This file is auto-generated. Do not modify manually.
// Model for collection chat_messages
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

class ChatMessagesModel {
  // Fields
  final String? id;
  static const String Id = 'id';

  final DateTime? created;
  static const String Created = 'created';

  final DateTime? updated;
  static const String Updated = 'updated';

  final dynamic chat;
  static const String Chat = 'chat';

  final String? content;
  static const String Content = 'content';

  final dynamic sender;
  static const String Sender = 'sender';

  const ChatMessagesModel({
    this.id,
    this.created,
    this.updated,
    this.chat,
    this.content,
    this.sender,
  });

  factory ChatMessagesModel.fromModel(RecordModel r) {
    return ChatMessagesModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      chat: r.data['chat'],
      content: r.data['content'],
      sender: r.data['sender'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chat': chat,
      'content': content,
      'sender': sender,
    };
  }
}
