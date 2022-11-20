import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/managers/cache_manager.dart';
import 'package:mineral/src/internal/mixins/container.dart';

class CommandManager extends CacheManager<CommandBuilder> with Container {
  final Snowflake? _guildId;

  CommandManager(this._guildId);

  Guild? get guild => container.use<MineralClient>().guilds.cache.get(_guildId);
}
