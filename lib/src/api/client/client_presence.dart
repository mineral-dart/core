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
  String? _label;
  int _type;
  String? _url;
  String _createdAt;
  Timestamp? _timestamps;
  Snowflake? _applicationId;
  String? _details;
  String? _state;
  // Emoji? emoji;
  // Party? party;
  // Asset? assets;
  // Secret? secrets;
  // Instance? instance;
  int? _flags;
  // List<Button> buttons;

  ClientPresence(
    this._label,
    this._type,
    this._url,
    this._createdAt,
    this._timestamps,
    this._applicationId,
    this._details,
    this._state,
    this._flags,
  );

  String? get label => _label;
  GamePresence get type => GamePresence.values.firstWhere((type) => type.value == _type);
  String? get url => _url;
  DateTime get createdAt => DateTime.parse(_createdAt);
  Timestamp? get timestamps =>  _timestamps != null ? Timestamp.from(payload: _timestamps) : null;
  Snowflake? get applicationId => _applicationId;
  String? get details => _details;
  String? get state => _state;
  int? get flags => _flags;

  factory ClientPresence.from({ required dynamic payload }) {
    return ClientPresence(
      payload['name'],
      payload['type'],
      payload['url'],
      payload['createdAt'],
      payload['timestamps'],
      payload['application_id'],
      payload['details'],
      payload['state'],
      payload['flags']
    );
  }
}
