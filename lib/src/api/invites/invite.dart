import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/invites/invite_target_type.dart';
import 'package:mineral/src/api/invites/wrapped_inviter.dart';
import 'package:mineral_ioc/ioc.dart';

class Invite {
  final int _type;
  final int _uses;
  final bool _temporary;
  final int _maxUses;
  final int _maxAge;
  final Snowflake? _inviterId;
  final Snowflake? _targetUserId;
  final Snowflake? _guildId;
  final String? _expiresAt;
  final String _createdAt;
  final String _code;
  final Snowflake? _channelId;
  final int? _targetType;

  Invite(
    this._type,
    this._uses,
    this._temporary,
    this._maxUses,
    this._maxAge,
    this._inviterId,
    this._targetUserId,
    this._guildId,
    this._expiresAt,
    this._createdAt,
    this._code,
    this._channelId,
    this._targetType,
  );

  /// Get guild [Guild] of this
  Guild get guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  /// Get type [int] of this
  int get type => _type;

  /// Get uses [int] of this
  int get uses => _uses;

  /// Get if this is temporary [bool] of this
  bool get isTemporary => _temporary;

  /// Get max uses [int] of this
  int get maxUses => _maxUses;

  /// Get max age [DateTime] of this
  DateTime get maxAge => DateTime.fromMillisecondsSinceEpoch(_maxAge);

  /// Get expires at [DateTime] of this
  DateTime? get expiresAt => _expiresAt != null
    ? DateTime.parse(_expiresAt!)
    : null;

  /// Get created at [DateTime] of this
  DateTime get createdAt => DateTime.parse(_createdAt);

  /// Get code [String] of this
  String get code => _code;

  /// Get channel [GuildChannel] of this
  GuildChannel? get channel => guild.channels.cache.get(_channelId);

  /// Get target type [InviteTargetType] of this
  InviteTargetType get targetType => InviteTargetType.values.firstWhere((element) => element.value == _targetType);

  /// Get inviter [WrappedInviter] of this
  WrappedInviter? getInviter () => _inviterId != null && _guildId != null
    ? WrappedInviter(_guildId!, _inviterId!)
    : null;

  /// Get target user [User] of this
  Future<User>? getTargetUser () => _targetUserId != null
    ? ioc.use<MineralClient>().users.resolve(_targetUserId!)
    : null;

  /// Get url [String] of this
  String get url => '${Constants.discordInviteHost}/$_code';

  /// Delete this invite
  ///
  /// ```dart
  /// Invite invite = guild.invites.cache.get('invite_code');
  /// invite.delete(reason: 'reason');
  /// ```
  Future<void> delete ({ String? reason }) async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/invites/$_code')
      .auditLog(reason)
      .build();
  }

  /// Get beautiful of this
  @override
  String toString () => url;

  factory Invite.from(Snowflake guildId, dynamic payload) => Invite(
    payload['type'],
    payload['uses'],
    payload['temporary'],
    payload['max_uses'],
    payload['max_age'],
    payload['inviter']?['id'],
    payload['target_user']?['id'],
    guildId,
    payload['expires_at'],
    payload['created_at'],
    payload['code'],
    payload['channel_id'],
    payload['target_type']
  );
}