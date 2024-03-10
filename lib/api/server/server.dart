import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

final class Server {
  final Snowflake id;
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

  static Future<Server> fromJson(MarshallerContract marshaller, Map<String, dynamic> json) async {
    final roles = RoleManager(Map<Snowflake, Role>.from(json['roles'].fold({}, (value, element) {
      final role = Role.fromJson(element);
      return {...value, role.id: role};
    })));

    final serializedMembers = await Future.wait(List.from(json['members']).map((element) async {
      return marshaller.serializers.member.serialize({...element, 'guild_roles': roles.list});
    }));

    final Map<Snowflake, Member> mappedMembers =
        serializedMembers.fold({}, (acc, member) => {...acc, member.id: member});

    final members = MemberManager(mappedMembers);

    final channels =
        await ChannelManager.fromJson(marshaller: marshaller, guildId: json['id'], json: json);

    final server = Server(
        id: json['id'],
        name: json['name'],
        members: members,
        settings: await marshaller.serializers.serverSettings.serialize(json),
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
