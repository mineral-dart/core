part of api;

enum StatusType {
  online('online'),
  doNotDisturb('dnd'),
  idle('idle'),
  invisible('invisible'),
  offline('offline');

  final String _value;
  const StatusType(this._value);

  @override
  String toString () => _value;
}

class Activity {
 String name;
 int type;

 Activity({ required this.name, required this.type });

 dynamic toJson () => { 'name': name, 'type': type };
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

  setPresence ({ Activity? activity, StatusType? status, bool? afk }) {
    WebsocketManager manager = ioc.singleton(Service.websocket);
    manager.send(OpCode.statusUpdate, {
      'since': DateTime.now().millisecond,
      'activities': activity != null ? [activity.toJson()] : [],
      'status': status != null ? status.toString() : StatusType.online.toString(),
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
