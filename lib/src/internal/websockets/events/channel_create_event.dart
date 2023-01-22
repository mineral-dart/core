import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ChannelCreateEvent extends Event {
  final PartialChannel _channel;

  ChannelCreateEvent(this._channel);

  PartialChannel get channel => _channel;
}
