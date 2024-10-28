import 'package:mineral/src/domains/events/contracts/private/private_button_click_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_dialog_submit_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_message_create_event.dart';
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

  void dialogSubmit(PrivateDialogSubmitEventHandler handle,
          {String? customId}) =>
      _events.make(Event.privateDialogSubmit, handle, customId: customId);

  void selectUser(PrivateUserSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.privateUserSelect, handle, customId: customId);

  void selectText(PrivateTextSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.privateTextSelect, handle, customId: customId);

  void pollAdd(PrivatePollVoteAddEventHandler handle) =>
      _events.make(Event.privatePollVoteAdd, handle);

  void pollRemove(PrivatePollVoteRemoveEventHandler handle) =>
      _events.make(Event.privatePollVoteRemove, handle);
}
