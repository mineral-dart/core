import 'package:mineral/api.dart';
import 'package:mineral/src/api/client/client_presence.dart';

class Status {
  User user;
  Snowflake guildId;
  Guild guild;
  PresenceType type;
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
      type: PresenceType.values.firstWhere((status) => status.value == payload['status']),
      user: guildMember.user,
      platform: payload['client_status'],
      activities: activities,
    );
  }
}
