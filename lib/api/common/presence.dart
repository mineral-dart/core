import 'package:mineral/api/common/activity.dart';

final class Presence {
  final DateTime? since;
  final List<Activity> activities;
  final String status;
  final bool afk;

  Presence({
    required this.since,
    required this.activities,
    required this.status,
    required this.afk,
  });

  factory Presence.fromJson(Map<String, dynamic> json) {
    return Presence(
      since: json['since'] != null ? DateTime.parse(json['since']) : null,
      activities: List<Activity>.from(json['activities'].map(Activity.fromJson)),
      status: json['status'],
      afk: json['afk'],
    );
  }
}