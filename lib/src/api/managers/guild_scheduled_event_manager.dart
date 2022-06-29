import 'package:mineral/api.dart';
import 'package:mineral/src/api/guilds/guild_scheduled_event.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class GuildScheduledEventManager implements CacheManager<GuildScheduledEvent> {
  @override
  Map<Snowflake, GuildScheduledEvent> cache = {};

  Snowflake? guildId;
  late Guild guild;

  GuildScheduledEventManager({ required this.guildId });

  @override
  Future<Map<Snowflake, GuildScheduledEvent>> sync() async {
    // TODO: implement sync
    throw UnimplementedError();
  }

}