// Model for Collection match_requests
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

enum StatusEnum {
  pending,
  matched,
}

final _statusEnumToMap = {
  StatusEnum.pending: "pending",
  StatusEnum.matched: "matched",
};
final _statusEnumFromMap = {
  "pending": StatusEnum.pending,
  "matched": StatusEnum.matched,
};

class MatchRequestsModel {
  // Fields
  final String id;
  static const String Id = 'id';

  final DateTime created;
  static const String Created = 'created';

  final DateTime updated;
  static const String Updated = 'updated';

  final dynamic userId;
  static const String UserId = 'user_id';

  final num budget;
  static const String Budget = 'budget';

  final num? distance;
  static const String Distance = 'distance';

  final DateTime? time;
  static const String Time = 'time';

  final num? latitude;
  static const String Latitude = 'latitude';

  final num? longitude;
  static const String Longitude = 'longitude';

  final StatusEnum status;
  static const String Status = 'status';

  final dynamic matchId;
  static const String MatchId = 'match_id';

  const MatchRequestsModel({
    required this.id,
    required this.created,
    required this.updated,
    this.userId,
    required this.budget,
    this.distance,
    this.time,
    this.latitude,
    this.longitude,
    required this.status,
    this.matchId,
  });

  factory MatchRequestsModel.fromModel(RecordModel r) {
    return MatchRequestsModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      userId: r.data['user_id'],
      budget: r.data['budget'],
      distance: r.data['distance'],
      time: r.data['time'],
      latitude: r.data['latitude'],
      longitude: r.data['longitude'],
      status: _statusEnumFromMap[r.data['status']]!,
      matchId: r.data['match_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'budget': budget,
      'distance': distance,
      'time': time,
      'latitude': latitude,
      'longitude': longitude,
      'status': _statusEnumToMap[status],
      'match_id': matchId,
    };
  }
}
