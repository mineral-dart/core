import 'dart:convert';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/guild_manager.dart';
import 'package:mineral/src/internal/websockets/sharding/shard.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_manager.dart';

import '../../internal/entities/command_manager.dart';

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

 dynamic toJson () => { 'name': name, 'type': type.toString() };
}

class MineralClient {
  User user;
  GuildManager guilds;
  String sessionId;
  Shard shard;
  Application application;
  List<Intent> intents;

  MineralClient({
    required this.user,
    required this.guilds,
    required this.sessionId,
    required this.shard,
    required this.application,
    required this.intents,
  });

  setPresence ({ ClientActivity? activity, ClientStatus? status, bool? afk }) {
    ShardManager manager = ioc.singleton(ioc.services.websocket);
    manager.send(OpCode.statusUpdate, {
      'since': DateTime.now().millisecond,
      'activities': activity != null ? [activity.toJson()] : [],
      'status': status != null ? status.toString() : ClientStatus.online.toString(),
      'afk': afk ?? false,
    });
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
    ShardManager manager = ioc.singleton(ioc.services.websocket);

    return MineralClient(
      user: User.from(payload['user']),
      guilds: GuildManager(),
      sessionId: payload['session_id'],
      shard: manager.shards[payload['shard'][0]]!,
      application: Application.from(payload['application']),
      intents: manager.intents
    );
  }
}
