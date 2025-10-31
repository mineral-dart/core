import 'package:mineral/src/domains/events/contracts/private/private_button_click_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_message_reaction_add_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_message_reaction_remove_all_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_message_reaction_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_modal_submit_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_poll_vote_add_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_poll_vote_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_text_select_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_user_select_event.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_bucket.dart';

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

  void modalSubmit(PrivateModalSubmitEventHandler handle, {String? customId}) =>
      _events.make(Event.privateModalSubmit, handle, customId: customId);

  void selectUser(PrivateUserSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.privateUserSelect, handle, customId: customId);

  void selectText(PrivateTextSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.privateTextSelect, handle, customId: customId);

  void privateMessageReactionAdd(PrivateMessageReactionAddHandler handle) =>
      _events.make(Event.privateMessageReactionAdd, handle);

  void privateMessageReactionRemove(
    PrivateMessageReactionRemoveHandler handle,
  ) =>
      _events.make(Event.privateMessageReactionRemove, handle);

  void messageReactionRemoveAll(
          PrivateMessageReactionRemoveAllHandler handle) =>
      _events.make(Event.privateMessageReactionRemoveAll, handle);

  void pollVoteAdd(PrivatePollVoteAddEventHandler handle) =>
      _events.make(Event.privatePollVoteAdd, handle);

  void pollVoteRemove(PrivatePollVoteRemoveEventHandler handle) =>
      _events.make(Event.privatePollVoteRemove, handle);
}
