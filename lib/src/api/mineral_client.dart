part of api;

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

  factory MineralClient.from({ required dynamic payload }) {
    return MineralClient(
      user: User.from(payload['user']),
      guilds: GuildManager(),
      sessionId: payload['session_id'],
      shards: payload['shards'] ?? [],
      application: Application.from(payload['application'])
    );
  }
}
