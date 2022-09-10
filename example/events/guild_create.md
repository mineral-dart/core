```dart
import 'package:mineral/mineral.dart';

@Event(Events.guildCreate)
class GuildCreate extends MineralEvent {
  Future<void> handle (Guild guild) async {
    // Your code here
  }
}
```
