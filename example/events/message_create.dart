import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@Event(Events.messageCreate)
class MessageCreate extends MineralEvent {
  Future<void> handle (Message message) async {
    // Your code here
  }
}
