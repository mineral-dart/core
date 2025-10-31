import 'package:mineral/api.dart';
import 'package:mineral/src/api/server/invite.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class InviteSerializer implements SerializerContract<Invite> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'channelId': json['channel_id'],
      'code': json['code'],
      'createdAt': json['created_at'],
      'expiresAt': json['expires_at'],
      'serverId': json['guild_id'],
      'inviterId': json['inviter']['id'],
      'maxAge': json['max_age'],
      'maxUses': json['max_uses'],
      'temporary': json['temporary'],
      'type': json['type'],
    };

    final cacheKey = _marshaller.cacheKey.voiceState(
      json['guild_id'],
      json['inviter']['id'],
    );
    await _marshaller.cache?.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<Invite> serialize(Map<String, dynamic> json) async {
    return Invite(
      type: InviteType.of(json['type']),
      code: json['code'],
      inviterId: Snowflake.parse(json['inviterId']),
      maxAge: Duration(seconds: json['maxAge']),
      maxUses: json['maxUses'],
      isTemporary: json['temporary'],
      channelId: Snowflake.parse(json['channelId']),
      serverId: Snowflake.parse(json['serverId']),
      createdAt: DateTime.parse(json['createdAt']),
      expiresAt: Helper.createOrNull(
        field: json['expiresAt'],
        fn: () => DateTime.parse(json['expiresAt']),
      ),
    );
  }

  @override
  Map<String, dynamic> deserialize(Invite invite) {
    return {
      'channelId': invite.channelId?.value,
      'code': invite.code,
      'createdAt': invite.createdAt.toIso8601String(),
      'expiresAt': invite.expiresAt?.toIso8601String(),
      'serverId': invite.serverId?.value,
      'inviterId': invite.inviterId.value,
      'maxAge': invite.maxAge.inSeconds,
      'maxUses': invite.maxUses,
      'temporary': invite.isTemporary,
      'type': invite.type.value,
    };
  }
}
