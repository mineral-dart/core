import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';

class CommandManager extends CacheManager<CommandBuilder> {
  final Snowflake? _guildId;

  CommandManager(this._guildId);

  Guild? get guild => ioc.singleton<MineralClient>(Service.client).guilds.cache.get(_guildId);
}
