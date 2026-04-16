import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class Bot {
  WebsocketOrchestratorContract get _wss =>
      ioc.resolve<WebsocketOrchestratorContract>();

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
  void setPresence(
          {List<BotActivity>? activities, StatusType? status, bool? afk}) =>
      _wss.setBotPresence(activities, status, afk);

  @override
  String toString() => '<@$id>';

  factory Bot.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final application = json['application'] as Map<String, dynamic>;
    return Bot._(
        id: Snowflake.parse(user['id']),
        discriminator: user['discriminator'] as String?,
        version: json['v'] as int,
        username: user['username'] as String,
        hasEnabledMfa: user['mfa_enabled'] as bool,
        globalName: user['global_name'] as String?,
        flags: user['flags'] as int,
        avatar: user['avatar'] as String?,
        sessionType: json['session_type'] as String,
        privateChannels: json['private_channels'] as List<dynamic>,
        presences: json['presences'] as List<dynamic>,
        guildIds: List<String>.from(
            (json['guilds'] as Iterable<dynamic>).map((element) => Snowflake.parse((element as Map<String, dynamic>)['id']))),
        application: PartialApplication(
          id: Snowflake.parse(application['id']),
          flags: application['flags'] as int,
        ),
    );
  }
}
