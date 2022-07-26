import 'package:mineral/api.dart';
import 'package:mineral/src/api/client/client_presence.dart';

class Activity {
  String? _label;
  GamePresence _type;
  String? _url;
  DateTime _createdAt;
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

  Activity(
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
  GamePresence get type => _type;
  String? get url => _url;
  DateTime get createdAt => _createdAt;
  Timestamp? get timestamps => _timestamps;
  Snowflake? get applicationId => _applicationId;
  String? get details => _details;
  String? get state => _state;
  int? get flags => _flags;

  factory Activity.from({ required dynamic payload }) {
    return Activity(
      payload['name'],
      GamePresence.values.firstWhere((status) => status.value == payload['type']),
      payload['url'],
      DateTime.fromMillisecondsSinceEpoch(payload['created_at']),
      payload['timestamps'] != null ? Timestamp.from(payload: payload['timestamps']) : null,
      payload['application_id'],
      payload['details'],
      payload['state'],
      payload['flags']
    );
  }
}
