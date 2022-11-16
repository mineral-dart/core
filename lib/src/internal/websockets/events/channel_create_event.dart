import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ChannelCreateEvent extends Event {
  final GuildChannel _channel;

  ChannelCreateEvent(this._channel);

  GuildChannel get channel => _channel;
}
