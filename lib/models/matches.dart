// Model for Collection matches
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

enum OverallStateEnum {
  pending,
  matched,
  unmatched,
  cancelled,
}

final _overallStateEnumToMap = {
  OverallStateEnum.pending: "pending",
  OverallStateEnum.matched: "matched",
  OverallStateEnum.unmatched: "unmatched",
  OverallStateEnum.cancelled: "cancelled",
};
final _overallStateEnumFromMap = {
  "pending": OverallStateEnum.pending,
  "matched": OverallStateEnum.matched,
  "unmatched": OverallStateEnum.unmatched,
  "cancelled": OverallStateEnum.cancelled,
};

class MatchesModel {
  // Fields
  final String id;
  static const String Id = 'id';

  final DateTime created;
  static const String Created = 'created';

  final DateTime updated;
  static const String Updated = 'updated';

  final String activity;
  static const String Activity = 'activity';

  final dynamic user1;
  static const String User1 = 'user1';

  final dynamic user2;
  static const String User2 = 'user2';

  final DateTime dateTime;
  static const String DateTimez = 'date_time';

  final bool? user1State;
  static const String User1State = 'user1_state';

  final bool? user2State;
  static const String User2State = 'user2_state';

  final OverallStateEnum overallState;
  static const String OverallState = 'overall_state';

  const MatchesModel({
    required this.id,
    required this.created,
    required this.updated,
    required this.activity,
    required this.user1,
    required this.user2,
    required this.dateTime,
    this.user1State,
    this.user2State,
    required this.overallState,
  });

  factory MatchesModel.fromModel(RecordModel r) {
    return MatchesModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      activity: r.data['activity'],
      user1: r.data['user1'],
      user2: r.data['user2'],
      dateTime: r.data['date_time'],
      user1State: r.data['user1_state'],
      user2State: r.data['user2_state'],
      overallState: _overallStateEnumFromMap[r.data['overall_state']]!,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activity': activity,
      'user1': user1,
      'user2': user2,
      'date_time': dateTime,
      'user1_state': user1State,
      'user2_state': user2State,
      'overall_state': _overallStateEnumToMap[overallState],
    };
  }
}
