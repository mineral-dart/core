import 'dart:async';

import 'package:mineral/api/common/channel.dart';
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
      await _marshaller.putRole(role.id.value, role);
      return role;
    }).wait;

    final serializedMembers = await List.from(json['members']).map((element) async {
      final member = await _marshaller.serializers.member
          .serializeRemote({...element, 'guild_roles': serializedRoles});

      await _marshaller.putMember(json['id'], member);
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

        await _marshaller.putChannel<ServerCategoryChannel>(channel.id.value, channel);
        return channel;
      }
    }).wait;

    await availableChannels.map((element) async {
      final channel = await serializeChannel(element);
      if (channel is ServerChannel) {
        channelManager.list.putIfAbsent(channel.id, () => channel);

        await _marshaller.putChannel<ServerChannel>(channel.id.value, channel);
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
      await assignCategoryChannel(channel);
    }

    for (final member in server.members.list.values) {
      member.server = server;
      member.roles.server = server;
      member.flags.server = server;
    }

    return server;
  }

  @override
  Future<Server> serializeCache(Map<String, dynamic> json) async {
    final roleIds = List.from(json['roles']);
    final List<Role> serializedRoles = await roleIds.map((element) async {
      final role = await _marshaller.getRole(element);
      return role.instance!;
    }).wait;

    final memberIds = List.from(json['members']);
    final serializedMembers = await memberIds.map((element) async {
      final member = await _marshaller.getMember(element);
      return member.instance!;
    }).wait;

    final channelManager = ChannelManager(json);


    final channelIds = List.from(json['channels']);
    await channelIds.map((element) async {
      final channel = await _marshaller.getChannel(element);
      if (channel.instance case final ServerChannel channel) {
        channelManager.list.putIfAbsent(channel.id, () => channel);
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
      await assignCategoryChannel(channel);
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

    final members = server.members.list.values
        .map((member) => '${server.id.value}.${member.id}');

    return {
      'id': server.id,
      'owner_id': server.owner.id,
      'name': server.name,
      'members': members,
      'roles': server.roles.list.keys.toList(),
      'channels': server.channels.list.keys.toList(),
      'description': server.description,
      'applicationId': server.applicationId,
      'assets': await _marshaller.serializers.serversAsset.deserialize(server.assets),
      'owner': await _marshaller.serializers.member.deserialize(server.owner),
      ...assets,
      ...settings,
    };
  }

  Future<void> assignCategoryChannel(ServerChannel channel) async {
    switch (channel) {
      case ServerCategoryChannel():
        break;
      case ServerTextChannel(:final categoryId):
        final categoryChannel =
            await _marshaller.getChannel<ServerCategoryChannel>(categoryId?.value);
        channel.category = categoryChannel.instance;
      case ServerVoiceChannel(:final categoryId):
        final categoryChannel =
            await _marshaller.getChannel<ServerCategoryChannel>(categoryId?.value);
        channel.category = categoryChannel.instance;
      case ServerAnnouncementChannel(:final categoryId):
        final categoryChannel =
            await _marshaller.getChannel<ServerCategoryChannel>(categoryId?.value);
        channel.category = categoryChannel.instance;
      case ServerForumChannel(:final categoryId):
        final categoryChannel =
            await _marshaller.getChannel<ServerCategoryChannel>(categoryId?.value);
        channel.category = categoryChannel.instance;
      case ServerStageChannel(:final categoryId):
        final categoryChannel =
            await _marshaller.getChannel<ServerCategoryChannel>(categoryId?.value);
        channel.category = categoryChannel.instance;
    }
  }
}
