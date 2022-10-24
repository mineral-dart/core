import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ChannelCreateEvent extends Event {
  final GuildChannel _channel;

  ChannelCreateEvent(this._channel);

  GuildChannel get channel => _channel;
}
