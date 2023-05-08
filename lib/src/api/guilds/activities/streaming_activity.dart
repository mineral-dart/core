import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';

/// Represents a streaming [Activity].
class StreamingActivity extends GuildMemberActivity {
  final String? _state;
  final String? _details;
  final String _url;

  StreamingActivity(
    String name,
    this._state,
    this._details,
    this._url,
  ): super(ActivityType.streaming, name);

  /// The state of this.
  String? get state => _state;

  /// The details of this.
  String? get details => _details;

  /// The url of this.
  String get url => _url;

  factory StreamingActivity.from(Snowflake guildId, dynamic payload) => StreamingActivity(
    payload['name'],
    payload['state'],
    payload['details'],
    payload['url'],
  );
}