import 'package:mineral/domains/events/contracts/private/private_button_click_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/event_bucket.dart';

final class PrivateBucket {
  final EventBucket _events;

  PrivateBucket(this._events);

  void messageCreate(PrivateMessageCreateEventHandler handle) =>
      _events.make(Event.privateMessageCreate, handle);

  void channelCreate(PrivateChannelCreateEventHandler handle) =>
      _events.make(Event.privateChannelCreate, handle);

  void channelPinsUpdate(PrivateChannelPinsUpdateEventHandler handle) =>
      _events.make(Event.privateChannelPinsUpdate, handle);

  void buttonClick(PrivateButtonClickEventHandler handle) =>
      _events.make(Event.privateButtonClick, handle);
}
