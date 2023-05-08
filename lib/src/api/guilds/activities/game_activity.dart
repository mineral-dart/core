import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/activities/assets_activity.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/activities/secret_activity.dart';

/// Represents a game [Activity].
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

  /// The id of this.
  String get id => _id;

  /// The state of this.
  String? get state => _state;

  /// The starting date of this.
  DateTime? get startingAt => _startingAt != null
    ? DateTime.fromMillisecondsSinceEpoch(_startingAt!)
    : null;

  /// The ending date of this.
  DateTime? get endAt => _endAt != null
    ? DateTime.fromMillisecondsSinceEpoch(_endAt!)
    : null;

  /// The creation date of this.
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(_createdAt);

  /// The details of this.
  String? get details => _details;

  /// The application id of this.
  String? get applicationId => _applicationId;

  /// The assets of this.
  AssetsActivity get assets => _assets;

  /// The secrets of this.
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