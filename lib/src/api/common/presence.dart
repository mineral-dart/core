import 'package:mineral/src/api/common/activity.dart';
import 'package:mineral/src/api/common/types/status_type.dart';

final class Presence {
  final DateTime? since;
  final List<Activity> activities;
  final StatusType status;
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
      activities: List<Activity>.from(
        json['activities'].map(
          (e) => Activity.fromJson(e),
        ),
      ),
      status: StatusType.values.firstWhere(
        (element) => element.value == json['status'],
      ),
      afk: json['afk'] ?? false,
    );
  }
}
