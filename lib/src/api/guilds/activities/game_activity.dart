import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/activities/assets_activity.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/activities/secret_activity.dart';

class GameActivity extends GuildMemberActivity {
  final String _id;
  final String? _state;
  final int? _startingAt;
  final int? _endAt;
  final int _createdAt;
  final String? _details;
  final String? _applicationId;
  final AssetsActivity _assets;
  final SecretActivity _secrets;

  GameActivity(
    String name,
    this._id,
    this._state,
    this._startingAt,
    this._endAt,
    this._createdAt,
    this._details,
    this._applicationId,
    this._assets,
    this._secrets,
  ): super(ActivityType.game, name);

  String get id => _id;

  String? get state => _state;

  int? get startingAt => _startingAt;

  DateTime? get endAt => _endAt != null
    ? DateTime.fromMicrosecondsSinceEpoch(_endAt!)
    : null;

  DateTime get createdAt => DateTime.fromMicrosecondsSinceEpoch(_createdAt);

  String? get details => _details;

  String? get applicationId => _applicationId;

  AssetsActivity get assets => _assets;

  SecretActivity get secrets => _secrets;

  factory GameActivity.from(Snowflake guildId, dynamic payload) => GameActivity(
    payload['name'],
    payload['id'],
    payload['state'],
    payload['timestamps']?['start'],
    payload['timestamps']?['end'],
    payload['created_at'],
    payload['details'],
    payload['application_id'],
    AssetsActivity(
      payload['assets']?['small_image'] != null
        ? ImageFormater(payload['assets']['large_image'], 'app-assets/${payload['application_id']}')
        : null,
      payload['assets']?['small_text'],
      payload['assets']?['large_image'] != null
        ? ImageFormater(payload['assets']['large_image'], 'app-assets/${payload['application_id']}')
        : null,
      payload['assets']?['large_text'],
    ),
    SecretActivity(
      payload['secrets']?['join'],
      payload['secrets']?['spectate'],
      payload['secrets']?['match'],
    )
  );
}