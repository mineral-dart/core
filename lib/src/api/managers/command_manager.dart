import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class CommandService extends CacheManager<AbstractCommand>  {
  final Snowflake? _guildId;

  CommandService(this._guildId);

  Guild? get guild => ioc.use<MineralClient>().guilds.cache.get(_guildId);
}
