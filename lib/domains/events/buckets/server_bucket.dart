import 'package:mineral/domains/events/contracts/server/server_thread_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_thread_delete_event.dart';
import 'package:mineral/domains/events/contracts/server/server_thread_update_event.dart';
import 'package:mineral/domains/events/event_bucket.dart';
import 'package:mineral/domains/events/contracts/server/server_ban_add_event.dart';
import 'package:mineral/domains/events/contracts/server/server_ban_remove_event.dart';
import 'package:mineral/domains/events/contracts/server/server_button_click_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_delete_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_delete_event.dart';
import 'package:mineral/domains/events/contracts/server/server_dialog_submit_event.dart';
import 'package:mineral/domains/events/contracts/server/server_emojis_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_add_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_remove_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_presence_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_role_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_roles_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_roles_remove_event.dart';
import 'package:mineral/domains/events/contracts/server/server_roles_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_stickers_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_text_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_update_event.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/event_bucket.dart';

final class ServerBucket {
  final EventBucket _events;

  ServerBucket(this._events);

  void serverCreate(ServerCreateEventHandler handle) => _events.make(Event.serverCreate, handle);

  void serverUpdate(ServerUpdateEventHandler handle) => _events.make(Event.serverUpdate, handle);

  void serverDelete(ServerDeleteEventHandler handle) => _events.make(Event.serverDelete, handle);

  void messageCreate(ServerMessageEventHandler handle) =>
      _events.make(Event.serverMessageCreate, handle);

  void channelCreate(ServerChannelCreateEventHandler handle) =>
      _events.make(Event.serverChannelCreate, handle);

  void channelUpdate(ServerChannelUpdateEventHandler handle) =>
      _events.make(Event.serverChannelUpdate, handle);

  void channelDelete(ServerChannelDeleteEventHandler handle) =>
      _events.make(Event.serverChannelDelete, handle);

  void channelPinsUpdate(ServerChannelPinsUpdateEventHandler handle) =>
      _events.make(Event.serverChannelPinsUpdate, handle);

  void memberAdd(ServerMemberAddEventHandler handle) => _events.make(Event.serverMemberAdd, handle);

  void memberRemove(ServerMemberRemoveEventHandler handle) =>
      _events.make(Event.serverMemberRemove, handle);

  void memberUpdate(ServerMemberUpdateEventHandler handle) =>
      _events.make(Event.serverMemberUpdate, handle);

  void roleCreate(ServerRolesCreateEventHandler handle) =>
      _events.make(Event.serverRoleCreate, handle);

  void roleUpdate(ServerRolesUpdateEventHandler handle) =>
      _events.make(Event.serverRoleUpdate, handle);

  void roleDelete(ServerRolesDeleteEventHandler handle) =>
      _events.make(Event.serverRoleDelete, handle);

  void presenceUpdate(ServerPresenceUpdateEventHandler handle) =>
      _events.make(Event.serverPresenceUpdate, handle);

  void banAdd(ServerBanAddEventHandler handle) => _events.make(Event.serverBanAdd, handle);

  void banRemove(ServerBanRemoveEventHandler handle) => _events.make(Event.serverBanRemove, handle);

  void emojisUpdate(ServerEmojisUpdateEventHandler handle) =>
      _events.make(Event.serverEmojisUpdate, handle);

  void stickersUpdate(ServerStickersUpdateEventHandler handle) =>
      _events.make(Event.serverStickersUpdate, handle);

  void buttonClick(ServerButtonClickEventHandler handle, {String? customId}) =>
      _events.make(Event.serverButtonClick, handle, customId: customId);

  void dialogSubmit<T>(ServerDialogSubmitEventHandler<T> handle, {String? customId}) =>
      _events.make(Event.serverDialogSubmit, handle, customId: customId);

  void selectChannel(ServerChannelSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.serverChannelSelect, handle, customId: customId);

  void selectRole(ServerRoleSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.serverRoleSelect, handle, customId: customId);

  void selectMember(ServerMemberSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.serverMemberSelect, handle, customId: customId);

  void selectText(ServerTextSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.serverTextSelect, handle, customId: customId);

  void threadCreate(ServerThreadCreateEventHandler handle) =>
      _events.make(Event.serverThreadCreate, handle);

  void threadUpdate(ServerThreadUpdateEventHandler handle) =>
      _events.make(Event.serverThreadUpdate, handle);

  void threadDelete(ServerThreadDeleteEventHandler handle) =>
      _events.make(Event.serverThreadDelete, handle);
}
