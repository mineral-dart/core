import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/emoji.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/activities/secret_activity.dart';

class CustomActivity extends GuildMemberActivity {
  final String _id;
  final String? _state;
  final PartialEmoji? _emoji;
  final String _createdAt;
  final SecretActivity _secrets;

  CustomActivity(
    String name,
    this._id,
    this._state,
    this._emoji,
    this._createdAt,
    this._secrets,
  ): super(ActivityType.custom, name);

  String get id => _id;
  String? get state => _state;
  PartialEmoji? get emoji => _emoji;
  String get createdAt => _createdAt;
  SecretActivity get secrets => _secrets;

  factory CustomActivity.from(Snowflake guildId, dynamic payload) => CustomActivity(
    payload['name'],
    payload['id'],
    payload['state'],
    payload['emoji'] != null
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