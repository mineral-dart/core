part of api;

class Status {
  User user;
  Snowflake guildId;
  Guild guild;
  StatusType type;
  List<Activity> activities;
  dynamic platform;

  Status({
    required this.user,
    required this.guildId,
    required this.guild,
    required this.type,
    required this.activities,
    required this.platform,
  });

  factory Status.from({ required Guild guild, required dynamic payload }) {
    GuildMember guildMember = guild.members.cache.get(payload['user']['id'])!;

    List<Activity> activities = [];

    for (dynamic element in payload['activities']) {
      Activity activity = Activity.from(payload: element);
      activities.add(activity);
    }

    return Status(
      guildId: payload['guild_id'],
      guild: guild,
      type: StatusType.values.firstWhere((status) => status.toString() == payload['status']),
      user: guildMember.user,
      platform: payload['client_status'],
      activities: activities,
    );
  }
}
