import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';

final class InvitePart implements InvitePartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Invite?> get(String code, bool force) async {
    final completer = Completer<Invite>();
    final String key = _marshaller.cacheKey.invite(code);

    final cachedInvite = await _marshaller.cache?.get(key);
    if (!force && cachedInvite != null) {
      final invite =
          await _marshaller.serializers.invite.serialize(cachedInvite);

      completer.complete(invite);
      return completer.future;
    }

    final req = Request.json(endpoint: '/invites/$code');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.invite.normalize(result);
    final invite = await _marshaller.serializers.invite.serialize(raw);

    completer.complete(invite);
    return completer.future;
  }

  @override
  Future<InviteMetadata?> getExtrasMetadata(String code, bool force) async {
    final completer = Completer<InviteMetadata>();

    final req = Request.json(endpoint: '/invites/$code', queryParameters: {
      'with_counts': 'true',
      'with_expiration': 'true',
    });

    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final metadata = InviteMetadata(
      approximateMemberCount: result['approximate_member_count'],
      approximatePresenceCount: result['approximate_presence_count'],
    );

    completer.complete(metadata);
    return completer.future;
  }

  // @override
  // Future<Role> create(
  //     Object serverId,
  //     String name,
  //     List<Permission> permissions,
  //     Color color,
  //     bool hoist,
  //     bool mentionable,
  //     String? reason) async {
  //   final completer = Completer<Role>();

  //   final req = Request.json(endpoint: '/guilds/$serverId/roles', body: {
  //     'name': name,
  //     'permissions': listToBitfield(permissions),
  //     'color': color.toInt(),
  //     'hoist': hoist,
  //     'mentionable': mentionable,
  //   }, headers: {
  //     DiscordHeader.auditLogReason(reason)
  //   });

  //   final result = await _dataStore.requestBucket
  //       .run<Map<String, dynamic>>(() => _dataStore.client.post(req));

  //   final raw = await _marshaller.serializers.role.normalize(result);
  //   final role = await _marshaller.serializers.role.serialize({
  //     ...raw,
  //     'guild_id': serverId,
  //   });

  //   completer.complete(role);
  //   return completer.future;
  // }

  @override
  Future<void> delete(String code, String? reason) async {
    final req = Request.json(
        endpoint: '/invites/$code',
        headers: {DiscordHeader.auditLogReason(reason)});

    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }
}
