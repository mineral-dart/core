import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';

class StreamingActivity extends GuildMemberActivity {
  final String _state;
  final String? _details;
  final String _url;

  StreamingActivity(
    String name,
    this._state,
    this._details,
    this._url,
  ): super(ActivityType.streaming, name);

  String? get state => _state;
  String? get details => _details;
  String get url => _url;

  factory StreamingActivity.from(Snowflake guildId, dynamic payload) => StreamingActivity(
    payload['name'],
    payload['state'],
    payload['details'],
    payload['url'],
  );
}