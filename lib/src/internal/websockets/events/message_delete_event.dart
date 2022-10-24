import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class MessageDeleteEvent extends Event {
  final Message _message;
  MessageDeleteEvent(this._message);

  Message get message => _message;
}
