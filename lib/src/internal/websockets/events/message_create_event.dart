import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MessageCreateEvent extends Event {
  final Message _message;
  MessageCreateEvent(this._message);

  Message get message => _message;
}
