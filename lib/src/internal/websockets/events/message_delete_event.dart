import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MessageDeleteEvent extends Event {
  final Message _message;
  MessageDeleteEvent(this._message);

  Message get message => _message;
}
