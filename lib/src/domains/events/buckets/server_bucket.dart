import 'package:mineral/src/domains/events/contracts/server/server_audit_log_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_ban_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_ban_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_button_click_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_channel_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_channel_delete_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_channel_pins_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_channel_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_channel_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_delete_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_modal_submit_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_emojis_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_chunk_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_message_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_message_reaction_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_message_reaction_remove_all_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_message_reaction_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_poll_vote_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_poll_vote_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_presence_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_role_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_roles_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_roles_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_roles_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_rule_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_rule_delete_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_rule_execution_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_rule_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_stickers_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_text_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_delete_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_member_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_member_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_member_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_update_event.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_bucket.dart';

final class ServerBucket {
  final EventBucket _events;

  ServerBucket(this._events);

  void serverCreate(ServerCreateEventHandler handle) =>
      _events.make(Event.serverCreate, handle);

  void serverUpdate(ServerUpdateEventHandler handle) =>
      _events.make(Event.serverUpdate, handle);

  void serverDelete(ServerDeleteEventHandler handle) =>
      _events.make(Event.serverDelete, handle);

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

  void memberAdd(ServerMemberAddEventHandler handle) =>
      _events.make(Event.serverMemberAdd, handle);

  void memberRemove(ServerMemberRemoveEventHandler handle) =>
      _events.make(Event.serverMemberRemove, handle);

  void memberUpdate(ServerMemberUpdateEventHandler handle) =>
      _events.make(Event.serverMemberUpdate, handle);

  void memberChunk(ServerMemberChunkEventHandler handle) =>
      _events.make(Event.serverMemberChunk, handle);

  void roleCreate(ServerRolesCreateEventHandler handle) =>
      _events.make(Event.serverRoleCreate, handle);

  void roleUpdate(ServerRolesUpdateEventHandler handle) =>
      _events.make(Event.serverRoleUpdate, handle);

  void roleDelete(ServerRolesDeleteEventHandler handle) =>
      _events.make(Event.serverRoleDelete, handle);

  void presenceUpdate(ServerPresenceUpdateEventHandler handle) =>
      _events.make(Event.serverPresenceUpdate, handle);

  void banAdd(ServerBanAddEventHandler handle) =>
      _events.make(Event.serverBanAdd, handle);

  void banRemove(ServerBanRemoveEventHandler handle) =>
      _events.make(Event.serverBanRemove, handle);

  void emojisUpdate(ServerEmojisUpdateEventHandler handle) =>
      _events.make(Event.serverEmojisUpdate, handle);

  void stickersUpdate(ServerStickersUpdateEventHandler handle) =>
      _events.make(Event.serverStickersUpdate, handle);

  void buttonClick(ServerButtonClickEventHandler handle, {String? customId}) =>
      _events.make(Event.serverButtonClick, handle, customId: customId);

  void modalSubmit<T>(ServerModalSubmitEventHandler<T> handle,
          {String? customId}) =>
      _events.make(Event.serverModalSubmit, handle, customId: customId);

  void selectChannel(ServerChannelSelectEventHandler handle,
          {String? customId}) =>
      _events.make(Event.serverChannelSelect, handle, customId: customId);

  void selectRole(ServerRoleSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.serverRoleSelect, handle, customId: customId);

  void selectMember(ServerMemberSelectEventHandler handle,
          {String? customId}) =>
      _events.make(Event.serverMemberSelect, handle, customId: customId);

  void selectText(ServerTextSelectEventHandler handle, {String? customId}) =>
      _events.make(Event.serverTextSelect, handle, customId: customId);

  void threadCreate(ServerThreadCreateEventHandler handle) =>
      _events.make(Event.serverThreadCreate, handle);

  void threadUpdate(ServerThreadUpdateEventHandler handle) =>
      _events.make(Event.serverThreadUpdate, handle);

  void threadDelete(ServerThreadDeleteEventHandler handle) =>
      _events.make(Event.serverThreadDelete, handle);

  void threadMemberUpdate(ServerThreadMemberUpdateEventHandler handle) =>
      _events.make(Event.serverThreadMemberUpdate, handle);

  void threadMemberAdd(ServerThreadMemberAddEventHandler handle) =>
      _events.make(Event.serverThreadMemberAdd, handle);

  void threadMemberRemove(ServerThreadMemberRemoveEventHandler handle) =>
      _events.make(Event.serverThreadMemberRemove, handle);

  void messageReactionAdd(ServerMessageReactionAddHandler handle) =>
      _events.make(Event.serverMessageReactionAdd, handle);

  void messageReactionRemove(ServerMessageReactionRemoveHandler handle) =>
      _events.make(Event.serverMessageReactionRemove, handle);

  void messageReactionRemoveAll(ServerMessageReactionRemoveAllHandler handle) =>
      _events.make(Event.serverMessageReactionRemoveAll, handle);

  void auditLog(ServerAuditLogEventHandler handle) =>
      _events.make(Event.serverAuditLog, handle);

  void pollVoteAdd(ServerPollVoteAddEventHandler handle) =>
      _events.make(Event.serverPollVoteAdd, handle);

  void pollVoteRemove(ServerPollVoteRemoveEventHandler handle) =>
      _events.make(Event.serverPollVoteRemove, handle);

  void ruleCreate(ServerRuleCreateEventHandler handle) =>
      _events.make(Event.serverRuleCreate, handle);

  void ruleUpdate(ServerRuleUpdateEventHandler handle) =>
      _events.make(Event.serverRuleUpdate, handle);

  void ruleDelete(ServerRuleDeleteEventHandler handle) =>
      _events.make(Event.serverRuleDelete, handle);

  void ruleExecution(ServerRuleExecutionEventHandler handle) =>
      _events.make(Event.serverRuleExecution, handle);
}
