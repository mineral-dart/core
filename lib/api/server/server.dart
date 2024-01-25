import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

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

  factory Server.fromJson(MarshallerContract marshaller, Map<String, dynamic> json) {
    final roles = RoleManager(Map<String, Role>.from(json['roles'].fold({}, (value, element) {
      final role = Role.fromJson(element);
      return {...value, role.id: role};
    })));

    // final members = MemberManager.fromJson(roles: roles, json: json['members']);
    final members = MemberManager(
      Map<String, Member>.from(json['members'].fold({}, (value, element) {
        final member = marshaller.serializers.member.serialize({
          ...element,
          'guild_roles': roles.list
        });
        return {...value, member.id: member};
      }))
    );

    final channels = ChannelManager.fromJson(marshaller: marshaller, guildId: json['id'], json: json);

    final server = Server(
        id: json['id'],
        name: json['name'],
        members: members,
        settings: marshaller.serializers.serverSettings.serialize(json),
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
