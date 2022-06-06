import 'package:mineral/api.dart';
import 'package:mineral/src/api/client/client_presence.dart';

class Activity {
  String? label;
  GamePresence type;
  String? url;
  DateTime createdAt;
  Timestamp timestamps;
  Snowflake? applicationId;
  String? details;
  String? state;
  // Emoji? emoji;
  // Party? party;
  // Asset? assets;
  // Secret? secrets;
  // Instance? instance;
  int? flags;
  // List<Button> buttons;

  Activity({
    required this.label,
    required this.type,
    required this.url,
    required this.createdAt,
    required this.timestamps,
    required this.applicationId,
    required this.details,
    required this.state,
    required this.flags,
  });

  factory Activity.from({ required dynamic payload }) {
    print(payload['type']);
    print(payload);
    return Activity(
      label: payload['name'],
      type: GamePresence.values.firstWhere((status) => status.value == payload['type']),
      url: payload['url'],
      createdAt: DateTime.parse(payload['created_at']),
      timestamps: Timestamp.from(payload: payload['timestamps']),
      applicationId: payload['application_id'],
      details: payload['details'],
      state: payload['state'],
      flags: payload['flags']
    );
  }
}
