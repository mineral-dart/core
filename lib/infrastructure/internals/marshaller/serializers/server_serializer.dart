import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
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

    final List<Role> serializedRoles = await Future.wait(roleWithoutEveryone.map((element) async {
      final role = await _marshaller.serializers.role.serializeRemote(element);

      await _marshaller.putRole(role.id.value, role);
      return role;
    }));

    final serializedMembers = await Future.wait(List.from(json['members']).map((element) async {
      final member = await _marshaller.serializers.member
          .serializeRemote({...element, 'guild_roles': serializedRoles});

      await _marshaller.putMember(member.id.value, member);
      return member;
    }));

    final channelManager =
        await ChannelManager.fromJson(marshaller: _marshaller, guildId: json['id'], json: json);

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

      switch (channel) {
        case ServerCategoryChannel(): break;
        case ServerTextChannel(:final categoryId) when categoryId != null: {
          final categoryChannel = await _marshaller.getChannel<ServerCategoryChannel>(categoryId.value);
          channel.category = categoryChannel.instance;
          break;
        }
        case ServerVoiceChannel(:final categoryId) when categoryId != null: {
          final categoryChannel = await _marshaller.getChannel<ServerCategoryChannel>(categoryId.value);
          channel.category = categoryChannel.instance;
          break;
        }
        case ServerAnnouncementChannel(:final categoryId) when categoryId != null: {
          final categoryChannel = await _marshaller.getChannel<ServerCategoryChannel>(categoryId.value);
          channel.category = categoryChannel.instance;
          break;
        }
        case ServerForumChannel(:final categoryId) when categoryId != null: {
          final categoryChannel = await _marshaller.getChannel<ServerCategoryChannel>(categoryId.value);
          channel.category = categoryChannel.instance;
          break;
        }
        case ServerStageChannel(:final categoryId) when categoryId != null: {
          final categoryChannel = await _marshaller.getChannel<ServerCategoryChannel>(categoryId.value);
          channel.category = categoryChannel.instance;
          break;
        }
      }
    }

    for (final member in server.members.list.values) {
      member.server = server;
      member.roles.server = server;
      member.flags.server = server;
    }

    return server;
  }

  @override
  Future<Server> serializeCache(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> deserialize(Server server) async {
    final assets = await _marshaller.serializers.serversAsset.deserialize(server.assets);
    final settings = await _marshaller.serializers.serverSettings.deserialize(server.settings);

    final members = await Future.wait(server.members.list.values
        .map((member) async => _marshaller.serializers.member.deserialize(member)));

    final channels = await Future.wait(server.channels.list.values
        .map((channel) async => _marshaller.serializers.channels.deserialize(channel)));

    final roles = await Future.wait(server.roles.list.values
        .map((role) async => _marshaller.serializers.role.deserialize(role)));

    return {
      'id': server.id,
      'owner_id': server.owner.id,
      'name': server.name,
      'members': members,
      'roles': roles,
      'channels': channels,
      'description': server.description,
      'applicationId': server.applicationId,
      'assets': await _marshaller.serializers.serversAsset.deserialize(server.assets),
      'owner': await _marshaller.serializers.member.deserialize(server.owner),
      ...assets,
      ...settings,
    };
  }
}
