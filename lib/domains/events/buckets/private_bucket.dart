import 'package:mineral/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_delete_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_add_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_remove_all_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_remove_emoji_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_remove_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_update_event.dart';
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

  void messageUpdate(PrivateMessageUpdateEventHandler handle) =>
      _events.make(Event.privateMessageUpdate, handle);

  void messageDelete(PrivateMessageDeleteEventHandler handle) =>
      _events.make(Event.privateMessageDelete, handle);

  void messageReactionAdd(PrivateMessageReactionAddEventHandler handle) =>
      _events.make(Event.privateMessageReactionAdd, handle);

  void messageReactionRemove(PrivateMessageReactionRemoveEventHandler handle) =>
      _events.make(Event.privateMessageReactionRemove, handle);

  void messageReactionRemoveAll(PrivateMessageReactionRemoveAllEventHandler handle) =>
      _events.make(Event.privateMessageReactionRemoveAll, handle);

  void messageReactionRemoveEmoji(PrivateMessageReactionRemoveEmojiEventHandler handle) =>
      _events.make(Event.privateMessageReactionRemoveEmoji, handle);
}