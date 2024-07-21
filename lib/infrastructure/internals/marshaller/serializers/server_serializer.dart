import 'dart:async';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
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
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSerializer implements SerializerContract<Server> {
  final MarshallerContract _marshaller;

  ServerSerializer(this._marshaller);

  @override
  Future<Server> serializeRemote(Map<String, dynamic> json) async {
    final roleWithoutEveryone =
        List.from(json['roles']).where((element) => element['id'] != json['id']);

    final List<Role> serializedRoles = await roleWithoutEveryone.map((element) async {
      final role = await _marshaller.serializers.role.serializeRemote(element);

      final rawRole = await _marshaller.serializers.role.deserialize(role);
      _marshaller.cache.put('server-${json['id']}/role-${role.id}', rawRole);

      return role;
    }).wait;

    final serializedMembers = await List.from(json['members']).map((element) async {
      final member = await _marshaller.serializers.member
          .serializeRemote({...element, 'guild_roles': serializedRoles});

      final rawMember = await _marshaller.serializers.member.deserialize(member);
      _marshaller.cache.put('server-${json['id']}/member-${member.id}', rawMember);

      return member;
    }).wait;

    final channelManager = ChannelManager(json);

    final availableCategoryChannels = List.from(json['channels'])
        .where((element) => element['type'] == ChannelType.guildCategory.value);

    final availableChannels = List.from(json['channels'])
        .where((element) => element['type'] != ChannelType.guildCategory.value);

    FutureOr<Channel?> serializeChannel(Map<String, dynamic> element) =>
        _marshaller.serializers.channels.serializeRemote({...element, 'guild_id': json['id']});

    await availableCategoryChannels.map((element) async {
      final channel = await serializeChannel(element);

      if (channel is ServerCategoryChannel) {
        channelManager.list.putIfAbsent(channel.id, () => channel);

        final rawChannel = await _marshaller.serializers.channels.deserialize(channel);
        await _marshaller.cache.put('server-${json['id']}/channel-${channel.id}', rawChannel);

        return channel;
      }
    }).wait;

    await availableChannels.map((element) async {
      final channel = await serializeChannel(element);
      if (channel is ServerChannel) {
        channelManager.list.putIfAbsent(channel.id, () => channel);

        final rawChannel = await _marshaller.serializers.channels.deserialize(channel);
        await _marshaller.cache.put('server-${json['id']}/channel-${channel.id}', rawChannel);

        return channel;
      }
    }).wait;

    final roleManager = RoleManager.fromList(serializedRoles);
    final owner = serializedMembers.firstWhere((member) => member.id == json['owner_id']);
    final serverAssets = await _marshaller.serializers.serversAsset
        .serializeRemote({'guildRoles': serializedRoles, ...json});

    final server = Server(
      id: json['id'],
      name: json['name'],
      members: MemberManager.fromList(serializedMembers),
      settings: await _marshaller.serializers.serverSettings.serializeRemote(json),
      roles: roleManager,
      channels: channelManager,
      description: json['description'],
      applicationId: json['application_id'],
      assets: serverAssets,
      owner: owner,
    );

    for (final channel in server.channels.list.values) {
      channel.server = server;
      await assignCategoryChannel(server.id, channel);
    }

    for (final member in server.members.list.values) {
      member.server = server;
      member.roles.server = server;
      member.flags.server = server;
    }

    return server;
  }

  @override
  Future<Server> serializeCache(Map<String, dynamic> payload) async {
    final serverKey = 'server-${payload['id']}';
    final rawServer = await _marshaller.cache.getOrFail(serverKey);
    final channelManager = ChannelManager(rawServer);

    final roles = await getCacheFromPrefix('$serverKey/role-');
    final List<Role> serializedRoles = await roles.map((element) async {
      return _marshaller.serializers.role.serializeCache(element.value);
    }).wait;

    final members = await getCacheFromPrefix('$serverKey/member-');
    final serializedMembers = await members.map((element) async {
      return _marshaller.serializers.member.serializeCache(element.value);
    }).wait;

    final channels =  await getCacheFromPrefix('$serverKey/channel-');
    await channels.map((element) async {
      final channel = await _marshaller.serializers.channels.serializeCache(element.value);
      if (channel case final ServerChannel channel) {
        channelManager.list.putIfAbsent(channel.id, () => channel);
        return channel;
      }
    }).wait;

    final roleManager = RoleManager.fromList(serializedRoles);
    final owner = serializedMembers.firstWhere((member) => member.id == rawServer['owner_id']);
    final serverAssets = await _marshaller.serializers.serversAsset
        .serializeCache({'guildRoles': serializedRoles, ...rawServer});

    final server = Server(
      id: rawServer['id'],
      name: rawServer['name'],
      members: MemberManager.fromList(serializedMembers),
      settings: await _marshaller.serializers.serverSettings.serializeCache(rawServer),
      roles: roleManager,
      channels: channelManager,
      description: rawServer['description'],
      applicationId: rawServer['application_id'],
      assets: serverAssets,
      owner: owner,
    );

    for (final channel in server.channels.list.values) {
      channel.server = server;
      await assignCategoryChannel(server.id, channel);
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
    final assets = await _marshaller.serializers.serversAsset.deserialize(server.assets);
    final settings = await _marshaller.serializers.serverSettings.deserialize(server.settings);

    final members = server.members.list.values.map((member) => '${server.id.value}.${member.id}');

    return {
      'id': server.id,
      'owner_id': server.owner.id,
      'name': server.name,
      'members': members,
      'description': server.description,
      'applicationId': server.applicationId,
      'assets': await _marshaller.serializers.serversAsset.deserialize(server.assets),
      'owner': await _marshaller.serializers.member.deserialize(server.owner),
      ...assets,
      ...settings,
    };
  }

  Future<Iterable<MapEntry<String, dynamic>>> getCacheFromPrefix(String key) async {
    final cache = await _marshaller.cache.getInternalValues();
    return cache.entries.where((element) => element.key.startsWith(key));
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

    final rawChannel = await _marshaller.cache.get('server-$serverId/channel-$categoryId');
    final category = rawChannel != null
        ? await _marshaller.serializers.channels.serializeCache(rawChannel)
        : null;

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
