import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ChannelDeleteEvent extends Event {
  final GuildChannel _channel;

  ChannelDeleteEvent(this._channel);

  GuildChannel get channel => _channel;
}
