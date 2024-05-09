import 'package:mineral/api/common/activity_emoji.dart';
import 'package:mineral/api/common/types/activity_type.dart';
import 'package:mineral/infrastructure/commons/helper.dart';

final class Activity {
  final String name;
  final ActivityType type;
  final String? url;
  final DateTime createdAt;
  final String? details;
  final String? state;
  final ActivityEmoji? emoji;

  Activity({
    required this.name,
    required this.type,
    required this.url,
    required this.createdAt,
    required this.details,
    required this.state,
    required this.emoji,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      name: json['name'],
      type: ActivityType.values[json['type']],
      url: json['url'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      details: json['details'],
      state: json['state'],
      emoji: Helper.createOrNull(field: json['emoji'], fn: () => ActivityEmoji(name: json['name'], id: json['id'], animated: json['animated'] ?? false))
    );
  }
}
