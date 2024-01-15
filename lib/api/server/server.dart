import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';

final class Server {
  final String id;
  final String? applicationId;
  final String name;
  final String? description;
  final Member owner;
  final MemberManager members;
  final ServerSettings settings;
  final RoleManager roles;
  final ChannelManager channels;
  final ServerAsset assets;

  Server({
    required this.id,
    required this.name,
    required this.members,
    required this.settings,
    required this.roles,
    required this.channels,
    required this.description,
    required this.applicationId,
    required this.assets,
    required this.owner,
  });

  factory Server.fromJson(MemoryStorageContract storage, Map<String, dynamic> json) {
    final roles = RoleManager(Map<String, Role>.from(json['roles'].fold({}, (value, element) {
      final role = Role.fromJson(element);
      return {...value, role.id: role};
    })));

    final members = MemberManager.fromJson(roles: roles, json: json['members']);

    final channels = ChannelManager.fromJson(storage: storage, guildId: json['id'], json: json);

    final server = Server(
        id: json['id'],
        name: json['name'],
        members: members,
        settings: ServerSettings.fromJson(json),
        roles: roles,
        channels: channels,
        description: json['description'],
        applicationId: json['application_id'],
        assets: ServerAsset.fromJson(roles, json),
        owner: members.getOrFail(json['owner_id']));

    for (final channel in server.channels.list.values) {
      channel.server = server;
    }

    for (final member in server.members.list.values) {
      member.server = server;
    }

    return server;
  }
}
