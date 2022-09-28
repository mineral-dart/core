import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/entities/command.dart';

class CommandManager extends CacheManager<SlashCommand> {
  final Snowflake _guildId;

  CommandManager(this._guildId);

  Guild get guild => ioc.singleton<MineralClient>(Service.client).guilds.cache.getOrFail(_guildId);
}
