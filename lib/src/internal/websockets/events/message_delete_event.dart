import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MessageDeleteEvent extends Event {
  final Message? _message;
  final Guild? _guild;

  MessageDeleteEvent(this._message, this._guild);

  Message? get message => _message;
  Guild? get guild => _guild;
}
