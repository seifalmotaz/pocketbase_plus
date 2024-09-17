// This file is auto-generated. Do not modify manually.
// Model for collection user_rating
// ignore_for_file: constant_identifier_names

import 'package:pocketbase/pocketbase.dart';

class UserRatingModel {
  // Fields
  final String? id;
  static const String Id = 'id';

  final DateTime? created;
  static const String Created = 'created';

  final DateTime? updated;
  static const String Updated = 'updated';

  final dynamic raterUserId;
  static const String RaterUserId = 'rater_user_id';

  final dynamic ratedUserId;
  static const String RatedUserId = 'rated_user_id';

  final num? ratingValue;
  static const String RatingValue = 'rating_value';

  final dynamic questions;
  static const String Questions = 'questions';

  const UserRatingModel({
    this.id,
    this.created,
    this.updated,
    this.raterUserId,
    this.ratedUserId,
    this.ratingValue,
    this.questions,
  });

  factory UserRatingModel.fromModel(RecordModel r) {
    return UserRatingModel(
      id: r.id,
      created: DateTime.parse(r.created),
      updated: DateTime.parse(r.updated),
      raterUserId: r.data['rater_user_id'],
      ratedUserId: r.data['rated_user_id'],
      ratingValue: r.data['rating_value'],
      questions: r.data['questions'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rater_user_id': raterUserId,
      'rated_user_id': ratedUserId,
      'rating_value': ratingValue,
      'questions': questions,
    };
  }
}
