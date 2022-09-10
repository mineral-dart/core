```dart
import 'package:mineral/mineral.dart';

@Event(Events.messageCreate)
class MessageCreate extends MineralEvent {
  Future<void> handle (Message message) async {
    // Your code here
  }
}
```
