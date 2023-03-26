import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/client_status_bucket.dart';

class GuildMemberPresence {
  final Snowflake _guildId;
  final String _status;
  final String? _premiumSince;
  final ClientStatusBucket _clientStatus;
  final List<GuildMemberActivity> _activities;

  GuildMemberPresence(this._guildId, this._status, this._premiumSince, this._clientStatus, this._activities);

  StatusType get status => StatusType.values.firstWhere((element) => element.value == _status);
  DateTime? get premiumSince => _premiumSince != null
    ? DateTime.parse(_premiumSince!)
    : null;
  ClientStatusBucket get clientStatus => _clientStatus;
  List<GuildMemberActivity> get activities => _activities;
}