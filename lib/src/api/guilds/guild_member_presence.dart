import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/guilds/activities/guild_member_activity.dart';
import 'package:mineral/src/api/guilds/client_status_bucket.dart';

/// Represents a presence of a [GuildMember].
class GuildMemberPresence {
  final Snowflake _guildId;
  final String _status;
  final String? _premiumSince;
  final ClientStatusBucket _clientStatus;
  final List<GuildMemberActivity> _activities;

  GuildMemberPresence(this._guildId, this._status, this._premiumSince, this._clientStatus, this._activities);

  /// Get the presence status.
  StatusType get status => StatusType.values.firstWhere((element) => element.value == _status);

  /// Get the premium since.
  DateTime? get premiumSince => _premiumSince != null
    ? DateTime.parse(_premiumSince!)
    : null;

  /// Get the client status.
  ClientStatusBucket get clientStatus => _clientStatus;

  /// Get the activities.
  List<GuildMemberActivity> get activities => _activities;
}