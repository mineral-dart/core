import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/managers/channel_manager.dart';
import 'package:mineral/api/server/managers/member_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_settings.dart';

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
}
