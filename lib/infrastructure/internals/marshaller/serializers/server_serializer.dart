import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_forum_channel.dart';
import 'package:mineral/api/server/channels/server_stage_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/managers/threads_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSerializer implements SerializerContract<Server> {
  final MarshallerContract _marshaller;

  ServerSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    await List.from(json['members']).map((element) async {
      return _marshaller.serializers.member.normalize({...element, 'server_id': json['id']});
    }).wait;

    await List.from(json['channels']).map((element) async {
      return _marshaller.serializers.channels.normalize({
        ...element,
        'server_id': json['id'],
      });
    }).wait;

    await _marshaller.serializers.serversAsset.normalize(json);
    await _marshaller.serializers.serverSettings.normalize(json);

    await List.from(json['threads']).map((element) async {
      return _marshaller.serializers.thread.normalize({
        ...element,
        'server_id': json['id'],
      });
    }).wait;

    final Map<String, dynamic> serverPayload = {
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
      'application_id': json['application_id'],
      'owner_id': _marshaller.cacheKey.member(json['id'], json['owner_id']),
      'assets': _marshaller.cacheKey.serverAssets(json['id']),
      'settings': _marshaller.cacheKey.serverSettings(json['id']),
      'roles': List.from(json['roles'])
          .map((element) => _marshaller.cacheKey.serverRole(json['id'], element['id']))
          .toList(),
      'members': List.from(json['members'])
          .map((element) => _marshaller.cacheKey.member(json['id'], element['user']['id']))
          .toList(),
      'channels': List.from(json['channels'])
          .map((element) => _marshaller.cacheKey.channel(element['id']))
          .toList(),
      'threads': List.from(json['threads'])
          .map((element) => _marshaller.cacheKey.thread(element['id']))
          .toList(),
    };

    final serverCacheKey = _marshaller.cacheKey.server(json['id']);
    await _marshaller.cache.put(serverCacheKey, serverPayload);

    return serverPayload;
  }

  @override
  Future<Server> serialize(Map<String, dynamic> payload) async {
    final rawMembers = await _marshaller.cache.getMany(payload['members']);
    final members = await rawMembers.nonNulls.map((element) async {
      return _marshaller.serializers.member.serialize({...element, 'server_id': payload['id']});
    }).wait;

    final rawRoles = await _marshaller.cache.getMany(payload['roles']);
    final roles = await rawRoles.nonNulls.map((element) async {
      return _marshaller.serializers.role.serialize(element);
    }).wait;

    final rawChannels = await _marshaller.cache.getMany(payload['channels']);
    final channels = await rawChannels.nonNulls.map((element) async {
      return _marshaller.serializers.channels.serialize(element) as Future<ServerChannel>;
    }).wait;

    final rawThreads = await _marshaller.cache.getMany(payload['threads']);

    final threads = await rawThreads.nonNulls.map((element) async {
      return _marshaller.serializers.thread.serialize(element);
    }).wait;

    final channelManager = ChannelManager.fromList(channels, payload);
    final threadManager = ThreadsManager.fromList(threads, payload);
    final roleManager = RoleManager.fromList(roles);

    final rawOwner = await _marshaller.cache.getOrFail(payload['owner_id']);
    final owner = await _marshaller.serializers.member.serialize(rawOwner);

    final rawAssets = await _marshaller.cache.getOrFail(payload['assets']);
    final serverAssets = await _marshaller.serializers.serversAsset.serialize(rawAssets);

    final rawSettings = await _marshaller.cache.getOrFail(payload['settings']);
    final serverSettings = await _marshaller.serializers.serverSettings.serialize(rawSettings);

    final server = Server(
      id: payload['id'],
      name: payload['name'],
      description: payload['description'],
      applicationId: payload['application_id'],
      members: MemberManager.fromList(members),
      settings: serverSettings,
      roles: roleManager,
      channels: channelManager,
      assets: serverAssets,
      threads: threadManager,
      owner: owner,
    );

    for (final channel in server.channels.list.values) {
      channel.server = server;
      await assignCategoryChannel(server.id, channel);
    }

    for (final thread in server.threads.list.values) {
      thread..server = server
      ..parentChannel = server.channels.list[Snowflake(thread.channelId)] as ServerTextChannel;
    }

    for (final member in server.members.list.values) {
      member.server = server;
      member.roles.server = server;
      member.flags.server = server;
    }

    return server;
  }

  @override
  Future<Map<String, dynamic>> deserialize(Server server) async {
    return {
      'id': server.id,
      'name': server.name,
      'description': server.description,
      'application_id': server.applicationId,
      'owner_id': _marshaller.cacheKey.member(server.id, server.owner.id),
      'assets': _marshaller.cacheKey.serverAssets(server.id),
      'settings': _marshaller.cacheKey.serverSettings(server.id),
      'roles': server.roles.list.keys
          .map((id) => _marshaller.cacheKey.serverRole(server.id, id))
          .toList(),
      'members':
          server.members.list.keys.map((id) => _marshaller.cacheKey.member(server.id, id)).toList(),
      'channels': server.channels.list.keys.map((id) => _marshaller.cacheKey.channel(id)).toList(),
      'threads': server.threads.list.keys
          .map((id) => _marshaller.cacheKey.thread(id))
          .toList(),
    };
  }

  Future<void> assignCategoryChannel(Snowflake serverId, ServerChannel channel) async {
    final categoryId = switch (channel) {
      ServerTextChannel(:final categoryId) => categoryId,
      ServerVoiceChannel(:final categoryId) => categoryId,
      ServerAnnouncementChannel(:final categoryId) => categoryId,
      ServerForumChannel(:final categoryId) => categoryId,
      ServerStageChannel(:final categoryId) => categoryId,
      _ => null,
    };

    if (categoryId == null) {
      return;
    }

    final channelCacheKey = _marshaller.cacheKey.channel(categoryId);
    final rawChannel = await _marshaller.cache.get(channelCacheKey);
    final category =
        rawChannel != null ? await _marshaller.serializers.channels.serialize(rawChannel) : null;

    if (category is ServerCategoryChannel?) {
      switch (channel) {
        case ServerTextChannel():
          channel.category = category;
        case ServerVoiceChannel():
          channel.category = category;
        case ServerAnnouncementChannel():
          channel.category = category;
        case ServerForumChannel():
          channel.category = category;
        case ServerStageChannel():
          channel.category = category;
      }
    }
  }
}
