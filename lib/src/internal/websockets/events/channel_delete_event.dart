import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ChannelDeleteEvent extends Event {
  final GuildChannel _channel;

  ChannelDeleteEvent(this._channel);

  GuildChannel get channel => _channel;
}
