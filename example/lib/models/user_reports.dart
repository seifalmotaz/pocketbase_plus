// This file is auto-generated. Do not modify manually.
// Model for collection user_reports
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

class UserReportsModel {
  // Fields
  final String? id;
  static const String Id = 'id';

  final DateTime? created;
  static const String Created = 'created';

  final DateTime? updated;
  static const String Updated = 'updated';

  final dynamic reporter;
  static const String Reporter = 'reporter';

  final dynamic reportedUser;
  static const String ReportedUser = 'reported_user';

  final String? reason;
  static const String Reason = 'reason';

  final bool? isResolved;
  static const String IsResolved = 'is_resolved';

  const UserReportsModel({
    this.id,
    this.created,
    this.updated,
    required this.reporter,
    required this.reportedUser,
    this.reason,
    this.isResolved,
  });

  factory UserReportsModel.fromModel(RecordModel r) {
    return UserReportsModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      reporter: r.data['reporter'],
      reportedUser: r.data['reported_user'],
      reason: r.data['reason'],
      isResolved: r.data['is_resolved'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reporter': reporter,
      'reported_user': reportedUser,
      'reason': reason,
      'is_resolved': isResolved,
    };
  }
}
