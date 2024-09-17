// This file is auto-generated. Do not modify manually.
// Model for collection matches
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

enum OverallStateEnum {
  pending("pending"),
  matched("matched"),
  unmatched("unmatched"),
  cancelled("cancelled"),
  ;

  final String value;

  const OverallStateEnum(this.value);

  static OverallStateEnum fromValue(String value) {
    return OverallStateEnum.values.firstWhere(
      (enumValue) => enumValue.value == value,
      orElse: () => throw ArgumentError("Invalid value: $value"),
    );
  }
}

class MatchesModel {
  // Fields
  final String? id;
  static const String Id = 'id';

  final DateTime? created;
  static const String Created = 'created';

  final DateTime? updated;
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
    this.id,
    this.created,
    this.updated,
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
      dateTime: DateTime.parse(r.data['date_time']! as String),
      user1State: r.data['user1_state'],
      user2State: r.data['user2_state'],
      overallState:
          OverallStateEnum.fromValue(r.data['overall_state']! as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activity': activity,
      'user1': user1,
      'user2': user2,
      'date_time': dateTime.toIso8601String(),
      'user1_state': user1State,
      'user2_state': user2State,
      'overall_state': overallState.value,
    };
  }
}
