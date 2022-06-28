import 'package:mineral/api.dart';

enum GamePresence {
  game(0),
  streaming(1),
  listening(2),
  watching(3),
  custom(4),
  competing(5);

  final int value;

  const GamePresence(this.value);

  @override
  String toString () => value.toString();
}

class Timestamp {
  DateTime? start;
  DateTime? end;

  Timestamp({ required this.start, required this.end });

  factory Timestamp.from ({ required dynamic payload }) {
    return Timestamp(
      start: payload['start'] != null ? DateTime.fromMillisecondsSinceEpoch(payload['start']) : null,
      end: payload['end'] != null ? DateTime.fromMillisecondsSinceEpoch(payload['end']) : null,
    );
  }
}

class ClientPresence {
  String? label;
  GamePresence type;
  String? url;
  DateTime createdAt;
  Timestamp? timestamps;
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

  ClientPresence({
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

  factory ClientPresence.from({ required dynamic payload }) {
    return ClientPresence(
      label: payload['name'],
      type: GamePresence.values.firstWhere((type) => type.toString() == payload['type']),
      url: payload['url'],
      createdAt: DateTime.parse(payload['createdAt']),
      timestamps: payload['timestamps'] != null ? Timestamp.from(payload: payload['timestamps']) : null,
      applicationId: payload['application_id'],
      details: payload['details'],
      state: payload['state'],
      flags: payload['flags']
    );
  }
}
