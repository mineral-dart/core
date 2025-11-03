import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class Bot {
  WebsocketOrchestratorContract get _wss => ioc.resolve<WebsocketOrchestratorContract>();

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
  }) {
    ioc.bind<Bot>(() => this);
  }

  /// Updates presence of this
  void setPresence({List<BotActivity>? activities, StatusType? status, bool? afk}) =>
      _wss.setBotPresence(activities, status, afk);

  @override
  String toString() => '<@$id>';

  factory Bot.fromJson(Map<String, dynamic> json) => Bot._(
        id: Snowflake.parse(json['user']['id']),
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
        guildIds: List<String>.from(json['guilds'].map((element) => Snowflake.parse(element['id']))),
        application: PartialApplication(
          id: Snowflake.parse(json['application']['id']),
          flags: json['application']['flags'],
        ),
      );
}
