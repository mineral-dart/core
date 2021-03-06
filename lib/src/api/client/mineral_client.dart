import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/dm_channel_manager.dart';
import 'package:mineral/src/api/managers/guild_manager.dart';
import 'package:mineral/src/api/managers/user_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';

import 'package:mineral/src/internal/managers/command_manager.dart';

enum Intent {
  guilds(1 << 0),
  guildMembers(1 << 1),
  guildBans(1 << 2),
  guildEmojisAndStickers(1 << 3),
  guildIntegrations(1 << 4),
  guildWebhooks(1 << 5),
  guildInvites(1 << 6),
  guildVoiceStates(1 << 7),
  guildPresences(1 << 8),
  guildMessages(1 << 9),
  guildMessageReactions(1 << 10),
  guildMessageTyping(1 << 11),
  directMessages(1 << 12),
  directMessageReaction(1 << 13),
  directMessageTyping(1 << 14),
  messageContent(1 << 17),
  guildScheduledEvents(1 << 16),
  autoModerationConfiguration(1 << 20),
  autoModerationExecution(1 << 21),
  all(0);

  final int value;
  const Intent(this.value);

  static int getIntent (List<Intent> intents) {
    List<int> values = [];

    List<Intent> source = intents.contains(Intent.all) ? Intent.values : intents;
    for (Intent intent in source) {
      values.add(intent.value);
    }

    return values.reduce((value, element) => value += element);
  }

  @override
  String toString () => value.toString();
}

enum ClientStatus {
  online('online'),
  doNotDisturb('dnd'),
  idle('idle'),
  invisible('invisible'),
  offline('offline');

  final String _value;
  const ClientStatus(this._value);

  @override
  String toString () => _value;
}

class ClientActivity {
 String name;
 GamePresence type;

 ClientActivity({ required this.name, required this.type });

 Object toJson () => { 'name': name, 'type': type.value };
}

class MineralClient {
  User user;
  GuildManager guilds;
  DmChannelManager dmChannels;
  UserManager users;
  String sessionId;
  Application application;
  List<Intent> intents;

  MineralClient({
    required this.user,
    required this.guilds,
    required this.dmChannels,
    required this.users,
    required this.sessionId,
    required this.application,
    required this.intents,
  });

  /// ### Defines the presence that this should adopt
  ///
  ///
  /// Example :
  /// ```dart
  /// client.setPresence(
  ///   activity: ClientActivity(name: 'My activity', type: GamePresence.listening),
  ///   status: ClientStatus.doNotDisturb
  /// );
  /// ```
  void setPresence ({ ClientActivity? activity, ClientStatus? status, bool? afk }) {
    ShardManager manager = ioc.singleton(ioc.services.shards);
    manager.send(OpCode.statusUpdate, {
      'since': DateTime.now().millisecond,
      'activities': activity != null ? [activity.toJson()] : [],
      'status': status != null ? status.toString() : ClientStatus.online.toString(),
      'afk': afk ?? false,
    });
  }

  /// Sends a ping/pong to the APi websocket of discord and returns the latency
  ///
  /// Example :
  /// ```dart
  /// final int latency = client.getLatency();
  /// ```
  int getLatency () {
    ShardManager manager = ioc.singleton(ioc.services.shards);
    return manager.getLatency();
  }

  Future<void> registerGlobalCommands ({ required List<SlashCommand> commands }) async {
    Http http = ioc.singleton(ioc.services.http);

    await http.put(
      url: "/applications/${application.id}/commands",
      payload: commands.map((command) => command.toJson()).toList()
    );
  }

  Future<void> registerGuildCommands ({ required Guild guild, required List<SlashCommand> commands}) async {
    Http http = ioc.singleton(ioc.services.http);

    await http.put(
      url: "/applications/${application.id}/guilds/${guild.id}/commands",
      payload: commands.map((command) => command.toJson()).toList()
    );
  }

  factory MineralClient.from({ required dynamic payload }) {
    ShardManager manager = ioc.singleton(ioc.services.shards);

    return MineralClient(
      user: User.from(payload['user']),
      guilds: GuildManager(),
      users: UserManager(),
      sessionId: payload['session_id'],
      application: Application.from(payload['application']),
      intents: manager.intents,
      dmChannels: DmChannelManager()
    );
  }
}
