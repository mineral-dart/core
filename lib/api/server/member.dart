import 'package:mineral/api/common/avatar_decoration.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/utils.dart';

final class Member {
  final String id;
  final String username;
  final String? nickname;
  final String? globalName;
  final String discriminator;
  final String? avatar;
  final AvatarDecoration? avatarDecoration;
  final int? flags;
  final DateTime? premiumSince;
  final int? publicFlags;
  late final Server server;
  final RoleManager roles;
  final bool isBot;

  Member._({
    required this.id,
    required this.username,
    required this.nickname,
    required this.globalName,
    required this.discriminator,
    required this.avatar,
    required this.avatarDecoration,
    required this.flags,
    required this.premiumSince,
    required this.publicFlags,
    required this.roles,
    required this.isBot,
  });

  factory Member.fromJson(MarshallerContract marshaller, Map<String, dynamic> json) {
    final serverRoles = json.entries.firstWhere((element) => element.key == 'guild_roles',
        orElse: () => throw FormatException('Server roles not found in member structure'));

    return Member._(
      id: json['user']['id'],
      username: json['user']['nick'] ?? json['user']['username'],
      nickname: json['nick'] ?? json['user']['display_name'],
      globalName: json['user']['global_name'],
      discriminator: json['user']['discriminator'],
      avatar: json['avatar'],
      avatarDecoration: createOrNull(
          field: json['user']?['avatar_decoration_data'],
          fn: () => AvatarDecoration.fromJson(json['user']['avatar_decoration_data'])),
      flags: json['flags'],
      premiumSince: createOrNull(
          field: json['premium_since'], fn: () => DateTime.parse(json['premium_since'])),
      publicFlags: json['user']['public_flags'],
      roles: RoleManager.fromJson(serverRoles.value, List<String>.from(json['roles'])),
      isBot: json['user']['bot'] ?? false,
    );
  }
}
