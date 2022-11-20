import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MessageCreateEvent extends Event {
  final Message _message;
  MessageCreateEvent(this._message);

  Message get message => _message;
}
