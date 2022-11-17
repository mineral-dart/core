import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MessageUpdateEvent extends Event {
  final Message? _before;
  final Message _after;

  MessageUpdateEvent(this._before, this._after);

  Message? get before => _before;
  Message get after => _after;
}
