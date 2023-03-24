import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/invites/invite_target_type.dart';
import 'package:mineral/src/api/invites/wrapped_inviter.dart';
import 'package:mineral/src/constants.dart';
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

  Guild get guild => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId);

  int get type => _type;

  int get uses => _uses;

  bool get isTemporary => _temporary;

  int get maxUses => _maxUses;

  DateTime get maxAge => DateTime.fromMillisecondsSinceEpoch(_maxAge);

  DateTime? get expiresAt => _expiresAt != null
    ? DateTime.parse(_expiresAt!)
    : null;

  DateTime get createdAt => DateTime.parse(_createdAt);

  String get code => _code;

  GuildChannel? get channel => guild.channels.cache.get(_channelId);

  InviteTargetType get targetType => InviteTargetType.values.firstWhere((element) => element.value == _targetType);

  WrappedInviter? getInviter () => _inviterId != null && _guildId != null
    ? WrappedInviter(_guildId!, _inviterId!)
    : null;

  Future<User>? getTargetUser () => _targetUserId != null
    ? ioc.use<MineralClient>().users.resolve(_targetUserId!)
    : null;

  String get url => '${Constants.discordInviteHost}/$_code';

  Future<void> delete ({ String? reason }) async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/invites/$_code')
      .auditLog(reason)
      .build();
  }

  @override
  String toString () => url;

  factory Invite.from(dynamic payload) => Invite(
    payload['type'],
    payload['uses'],
    payload['temporary'],
    payload['max_uses'],
    payload['max_age'],
    payload['inviter']?['id'],
    payload['target_user']?['id'],
    payload['guild_id'],
    payload['expires_at'],
    payload['created_at'],
    payload['code'],
    payload['channel_id'],
    payload['target_type']
  );
}