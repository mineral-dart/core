import 'package:mineral/domains/events/event_bucket.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';

final class PrivateBucket {
  final EventBucket _events;

  PrivateBucket(this._events);

  void messageCreate(PrivateMessageEventHandler handle) =>
      _events.make(MineralEvent.privateMessageCreate, handle);

  void channelCreate(PrivateChannelCreateEventHandler handle) =>
      _events.make(MineralEvent.privateChannelCreate, handle);

  void channelPinsUpdate(PrivateChannelPinsUpdateEventHandler handle) =>
      _events.make(MineralEvent.privateChannelPinsUpdate, handle);
}
