import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/emoji.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/activities/secret_activity.dart';

/// Represents a custom [Activity].
class CustomActivity extends GuildMemberActivity {
  final String _id;
  final String? _state;
  final PartialEmoji? _emoji;
  final int _createdAt;
  final SecretActivity _secrets;

  CustomActivity(
    String name,
    this._id,
    this._state,
    this._emoji,
    this._createdAt,
    this._secrets,
  ): super(ActivityType.custom, name);

  /// Returns the id of this.
  String get id => _id;

  /// Returns the state of this.
  String? get state => _state;

  /// Returns the emoji of this.
  PartialEmoji? get emoji => _emoji;

  /// Returns the creation date of this.
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(_createdAt);

  /// Returns the secrets of this.
  SecretActivity get secrets => _secrets;

  factory CustomActivity.from(Snowflake guildId, dynamic payload) => CustomActivity(
    payload['name'],
    payload['id'],
    payload['state'],
    payload['emoji']?['id'] != null
      ? PartialEmoji(payload['emoji']['id'], payload['emoji']['name'], payload['emoji']['animated'])
      : null,
    payload['created_at'],
    SecretActivity(
      payload['secrets']?['join'],
      payload['secrets']?['spectate'],
      payload['secrets']?['match'],
    )
  );
}