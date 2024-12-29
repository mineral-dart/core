import 'dart:async';

import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/channel_manager.dart';
import 'package:mineral/src/api/server/managers/member_manager.dart';
import 'package:mineral/src/api/server/managers/role_manager.dart';
import 'package:mineral/src/api/server/managers/threads_manager.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSerializer implements SerializerContract<Server> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    await _marshaller.serializers.serversAsset.normalize(json);
    await _marshaller.serializers.serverSettings.normalize(json);

    final Map<String, dynamic> serverPayload = {
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
      'application_id': json['application_id'],
      'owner_id': json['owner_id'],
      'assets': _marshaller.cacheKey.serverAssets(json['id']),
      'settings': _marshaller.cacheKey.serverSettings(json['id']),
      'channel_settings': {
        'afk_channel_id': json['afk_channel_id'],
        'system_channel_id': json['system_channel_id'],
        'rules_channel_id': json['rules_channel_id'],
        'public_updates_channel_id': json['public_updates_channel_id'],
        'safety_alerts_channel_id': json['safety_alerts_channel_id'],
      },
    };

    final serverCacheKey = _marshaller.cacheKey.server(json['id']);
    await _marshaller.cache.put(serverCacheKey, serverPayload);

    return serverPayload;
  }

  @override
  Future<Server> serialize(Map<String, dynamic> payload) async {
    final channelManager = ChannelManager.fromMap(payload['id'], payload['channel_settings']);
    final threadManager = ThreadsManager(payload['id']);
    final roleManager = RoleManager(payload['id']);
    final memberManager = MemberManager(payload['id']);

    final rawAssets = await _marshaller.cache.getOrFail(payload['assets']);
    final serverAssets =
        await _marshaller.serializers.serversAsset.serialize(rawAssets);

    final rawSettings = await _marshaller.cache.getOrFail(payload['settings']);
    final serverSettings =
        await _marshaller.serializers.serverSettings.serialize(rawSettings);

    return Server(
      id: payload['id'],
      name: payload['name'],
      description: payload['description'],
      applicationId: payload['application_id'],
      members: memberManager,
      settings: serverSettings,
      roles: roleManager,
      channels: channelManager,
      assets: serverAssets,
      threads: threadManager,
      ownerId: Snowflake(payload['owner_id']),
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(Server server) async {
    return {
      'id': server.id,
      'name': server.name,
      'description': server.description,
      'application_id': server.applicationId,
      'owner_id': server.ownerId,
      'assets': _marshaller.cacheKey.serverAssets(server.id.value),
      'settings': _marshaller.cacheKey.serverSettings(server.id.value),
      'channel_settings': {
        'afk_channel_id': server.channels.afkChannelId?.value,
        'system_channel_id': server.channels.systemChannelId?.value,
        'rules_channel_id': server.channels.rulesChannelId?.value,
        'public_updates_channel_id': server.channels.publicUpdatesChannelId?.value,
        'safety_alerts_channel_id': server.channels.safetyAlertsChannelId?.value,
      },
    };
  }
}
