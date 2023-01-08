import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';

class DMChannelCreateEvent extends Event {
  final DmChannel _channel;

  DMChannelCreateEvent(this._channel);

  DmChannel get channel => _channel;
}
