import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/dm_channel_manager.dart';
import 'package:mineral/src/api/managers/guild_manager.dart';
import 'package:mineral/src/api/managers/user_manager.dart';
import 'package:mineral/src/internal/entities/command.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';

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
  User _user;
  GuildManager _guilds;
  DmChannelManager _dmChannels;
  UserManager _users;
  String _sessionId;
  Application _application;
  List<Intent> _intents;
  late DateTime uptime;

  MineralClient(
    this._user,
    this._guilds,
    this._dmChannels,
    this._users,
    this._sessionId,
    this._application,
    this._intents,
  );

  User get user => _user;
  GuildManager get guilds => _guilds;
  DmChannelManager get dmChannels => _dmChannels;
  UserManager get users => _users;
  String get sessionId => _sessionId;
  Application get application => _application;
  List<Intent> get intents => _intents;
  ShardManager get _shards => ioc.singleton(Service.shards);

  /// ### Returns the time the [MineralClient] is online
  Duration get uptimeDuration => DateTime.now().difference(uptime);

  /// ### Defines the presence that this should adopt
  ///
  /// Example :
  /// ```dart
  /// client.setPresence(
  ///   activity: ClientActivity(name: 'My activity', type: GamePresence.listening),
  ///   status: ClientStatus.doNotDisturb
  /// );
  /// ```
  void setPresence ({ ClientActivity? activity, ClientStatus? status, bool? afk }) {
    _shards.send(OpCode.statusUpdate, {
      'since': DateTime.now().millisecond,
      'activities': activity != null ? [activity.toJson()] : [],
      'status': status != null ? status.toString() : ClientStatus.online.toString(),
      'afk': afk ?? false,
    });
  }

  /// Define activities of this
  void setActivities (List<ClientActivity> activities) {
    _shards.send(OpCode.statusUpdate, {
      'activities': activities.map((activity) => activity.toJson()),
    });
  }

  /// Define status of this
  void setStatus (ClientStatus status) {
    _shards.send(OpCode.statusUpdate, {
      'status': status._value,
    });
  }


  /// Define afk of this
  void setAfk (bool afk) {
    _shards.send(OpCode.statusUpdate, {
      'afk': afk,
    });
  }

  /// Sends a ping/pong to the APi websocket of discord and returns the latency
  ///
  /// Example :
  /// ```dart
  /// final int latency = client.getLatency();
  /// ```
  int getLatency () {
    ShardManager manager = ioc.singleton(Service.shards);
    return manager.getLatency();
  }

  Future<void> registerGlobalCommands ({ required List<SlashCommand> commands }) async {
    Http http = ioc.singleton(Service.http);

    await http.put(
      url: "/applications/${_application.id}/commands",
      payload: commands.map((command) => command.toJson()).toList()
    );
  }

  Future<void> registerGuildCommands ({ required Guild guild, required List<SlashCommand> commands, required List<MineralContextMenu> contextMenus }) async {
    for (final command in commands) {
      guild.commands.cache.putIfAbsent(command.name, () => command);
    }

    Http http = ioc.singleton(Service.http);
    Response response = await http.put(
      url: "/applications/${_application.id}/guilds/${guild.id}/commands",
      payload: [
        ...commands.map((command) => command.toJson()).toList(),
        ...contextMenus.map((contextMenus) => contextMenus.toJson()).toList()
      ]
    );

    print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> _commands = jsonDecode(response.body);
      for (final element in _commands) {
        final command = commands.firstWhere((command) => command.name == element['name']);
        if (command.scope == 'GUILD' || command.scope == guild.id) {
          command.id = element['id'];
          guild.commands.cache.putIfAbsent(command.name, () => command);
        }
      }
    }
  }

  factory MineralClient.from({ required dynamic payload }) {
    ShardManager manager = ioc.singleton(Service.shards);

    return MineralClient(
      User.from(payload['user']),
      GuildManager(),
      DmChannelManager(),
      UserManager(),
      payload['session_id'],
      Application.from(payload['application']),
      manager.intents,
    );
  }
}
