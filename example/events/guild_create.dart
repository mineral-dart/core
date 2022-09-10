import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@Event(Events.guildCreate)
class GuildCreate extends MineralEvent {
  Future<void> handle (Guild guild) async {
    // Your code here
  }
}
