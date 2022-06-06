import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/client/client_presence.dart';
import 'package:mineral/src/api/managers/guild_manager.dart';
import 'package:mineral/src/internal/websockets/websocket_manager.dart';

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
  List<Map<String, int>> shards;
  Application application;

  MineralClient({
    required this.user,
    required this.guilds,
    required this.sessionId,
    required this.shards,
    required this.application,
  });

  setPresence ({ ClientActivity? activity, ClientStatus? status, bool? afk }) {
    WebsocketManager manager = ioc.singleton(Service.websocket);
    manager.send(OpCode.statusUpdate, {
      'since': DateTime.now().millisecond,
      'activities': activity != null ? [activity.toJson()] : [],
      'status': status != null ? status.toString() : ClientStatus.online.toString(),
      'afk': afk ?? false,
    });
  }

  factory MineralClient.from({ required dynamic payload }) {
    return MineralClient(
      user: User.from(payload['user']),
      guilds: GuildManager(),
      sessionId: payload['session_id'],
      shards: payload['shards'] ?? [],
      application: Application.from(payload['application']),
    );
  }
}
