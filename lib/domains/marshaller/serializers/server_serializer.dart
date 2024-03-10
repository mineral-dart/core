import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerSerializer implements SerializerContract<Server> {
  final MarshallerContract _marshaller;

  ServerSerializer(this._marshaller);

  @override
  Future<Server> serialize(Map<String, dynamic> json) async {
    final serializedRoles = await Future.wait(List.from(json['roles'])
        .map((element) async => _marshaller.serializers.role.serialize(element)));

    final serializedMembers = await Future.wait(List.from(json['members']).map((element) async =>
        _marshaller.serializers.member.serialize({...element, 'guild_roles': serializedRoles})));

    final channelManager =
        await ChannelManager.fromJson(marshaller: _marshaller, guildId: json['id'], json: json);

    final roleManager = RoleManager.fromList(serializedRoles);
    final owner = serializedMembers.firstWhere((member) => member.id == json['owner_id']);

    final server = Server(
      id: json['id'],
      name: json['name'],
      members: MemberManager.fromList(serializedMembers),
      settings: await _marshaller.serializers.serverSettings.serialize(json),
      roles: roleManager,
      channels: channelManager,
      description: json['description'],
      applicationId: json['application_id'],
      assets: await _marshaller.serializers.serversAsset.serialize({
        'guildRoles': serializedRoles,
        ...json
      }),
      owner: owner,
    );

    for (final channel in server.channels.list.values) {
      channel.server = server;
    }

    for (final member in server.members.list.values) {
      member.server = server;
    }

    return server;
  }

  @override
  Map<String, dynamic> deserialize(Server server) {
    final members = server.members.list.values.map(_marshaller.serializers.member.deserialize);
    final roles = server.roles.list.values.map(_marshaller.serializers.role.deserialize);
    final channels = server.channels.list.values.map(_marshaller.serializers.channels.deserialize);
    final assets = _marshaller.serializers.serversAsset.deserialize(server.assets);

    return {
      'id': server.id,
      'name': server.name,
      'members': members.toList(),
      'settings': _marshaller.serializers.serverSettings.deserialize(server.settings),
      'roles': roles.toList(),
      'channels': channels.toList(),
      'description': server.description,
      'applicationId': server.applicationId,
      'assets': _marshaller.serializers.serversAsset.deserialize(server.assets),
      'owner': _marshaller.serializers.member.deserialize(server.owner),
      ...assets
    };
  }
}
