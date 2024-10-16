import 'package:mineral/src/api/common/partial_application.dart';
import 'package:mineral/src/api/common/snowflake.dart';

final class Bot {
  final Snowflake id;
  final String? discriminator;
  final int version;
  final String username;
  final bool hasEnabledMfa;
  final String? globalName;
  final int flags;
  final String? avatar;
  final String sessionType;
  final List privateChannels;
  final List presences;
  final List<String> guildIds;
  final PartialApplication application;

  Bot._({
    required this.id,
    required this.discriminator,
    required this.version,
    required this.username,
    required this.hasEnabledMfa,
    required this.globalName,
    required this.flags,
    required this.avatar,
    required this.sessionType,
    required this.privateChannels,
    required this.presences,
    required this.guildIds,
    required this.application,
  });

  @override
  String toString() {
    return '<@$id>';
  }

  factory Bot.fromJson(Map<String, dynamic> json) => Bot._(
        id: Snowflake(json['user']['id']),
        discriminator: json['user']['discriminator'],
        version: json['v'],
        username: json['user']['username'],
        hasEnabledMfa: json['user']['mfa_enabled'],
        globalName: json['user']['global_name'],
        flags: json['user']['flags'],
        avatar: json['user']['avatar'],
        sessionType: json['session_type'],
        privateChannels: json['private_channels'],
        presences: json['presences'],
        guildIds:
            List<String>.from(json['guilds'].map((element) => element['id'])),
        application: PartialApplication(
          id: json['application']['id'],
          flags: json['application']['flags'],
        ),
      );
}
