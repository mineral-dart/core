import 'package:mineral/src/api/common/types/enhanced_enum.dart';
import 'package:mineral/src/domains/events/contracts/common/ready_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_button_click_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_delete_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_channel_update_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_dialog_submit_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_text_select_event.dart';
import 'package:mineral/src/domains/events/contracts/private/private_user_select_event.dart';
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
import 'package:mineral/src/domains/events/contracts/server/server_dialog_submit_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_emojis_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_chunk_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_member_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_message_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_presence_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_role_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_roles_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_roles_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_roles_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_stickers_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_text_select_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_create_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_delete_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_list_sync_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_member_add_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_member_remove_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_member_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_thread_update_event.dart';
import 'package:mineral/src/domains/events/contracts/server/server_update_event.dart';

interface class EventType {}

enum Event implements EnhancedEnum, EventType {
  ready(ReadyEvent, ['Bot bot']),
  serverCreate(ServerCreateEvent, ['Server server']),
  serverUpdate(ServerUpdateEvent, ['Server before', 'Server after']),
  serverDelete(ServerDeleteEvent, ['Server? server']),
  serverMessageCreate(ServerMessageCreateEvent, ['ServerMessage message']),
  serverChannelCreate(ServerChannelCreateEvent, ['ServerChannel channel']),
  serverChannelUpdate(ServerChannelUpdateEvent,
      ['ServerChannel before', 'ServerChannel after']),
  serverChannelDelete(ServerChannelDeleteEvent, ['ServerChannel? channel']),
  serverChannelPinsUpdate(
      ServerChannelPinsUpdateEvent, ['ServerChannel channel']),
  privateChannelPinsUpdate(
      PrivateChannelPinsUpdateEvent, ['PrivateChannel channel']),
  serverMemberAdd(ServerMemberAddEvent, ['Server server', 'Member member']),
  serverMemberRemove(ServerMemberRemoveEvent, ['Server server', 'User user']),
  serverBanAdd(ServerBanAddEvent, ['Server server', 'User user']),
  serverBanRemove(ServerBanRemoveEvent, ['Server server', 'User user']),
  serverMemberUpdate(ServerMemberUpdateEvent,
      ['Server server', 'ServerMember? before', 'Member after']),
  serverPresenceUpdate(ServerPresenceUpdateEvent,
      ['Member member', 'Server server', 'Presence presence']),
  serverEmojisUpdate(
      ServerEmojisUpdateEvent, ['Map<Snowflake, Emoji> emojis', 'Server server']),
  serverStickersUpdate(ServerStickersUpdateEvent,
      ['Server server', 'Map<Snowflake, Sticker> stickers']),
  serverRoleCreate(ServerRolesCreateEvent, ['Server server', 'Role role']),
  serverRoleUpdate(
      ServerRolesUpdateEvent, ['Server server', 'Role before', 'Role after']),
  serverRoleDelete(ServerRolesDeleteEvent, ['Server server', 'Role? role']),
  serverButtonClick(ServerButtonClickEvent, ['ServerButtonContext ctx']),
  serverDialogSubmit(ServerDialogSubmitEvent, ['ServerDialogContext ctx']),
  serverChannelSelect(ServerChannelSelectEvent,
      ['ServerSelectContext ctx', 'List<ServerChannel> channels']),
  serverRoleSelect(
      ServerRoleSelectEvent, ['ServerSelectContext ctx', 'List<Role> roles']),
  serverMemberSelect(ServerMemberSelectEvent,
      ['ServerSelectContext ctx', 'List<Member> members']),
  serverTextSelect(ServerTextSelectEvent,
      ['ServerSelectContext ctx', 'List<String> values']),
  serverThreadCreate(
      ServerThreadCreateEvent, ['ThreadChannel channel', 'Server server']),
  serverThreadUpdate(ServerThreadUpdateEvent,
      ['ThreadChannel before', 'ThreadChannel after', 'Server server']),
  serverThreadDelete(
      ServerThreadDeleteEvent, ['ThreadChannel thread', 'Server server']),
  serverThreadMemberUpdate(ServerThreadMemberUpdateEvent,
      ['ThreadChannel thread', 'Server server', 'Member member']),
  serverThreadMemberAdd(ServerThreadMemberAddEvent,
      ['ThreadChannel thread', 'Server server', 'Member member']),
  serverThreadMemberRemove(ServerThreadMemberRemoveEvent,
      ['ThreadChannel thread', 'Server server', 'Member member']),
  serverThreadListSync(ServerThreadListSyncEvent,
      ['List<ThreadChannel> threads', 'Server server']),
  serverMemberChunk(ServerMemberChunkEvent, ['Server server', 'Map<Snowflake, Member> members']),

  // private
  privateMessageCreate(PrivateMessageCreateEvent, ['PrivateMessage message']),
  privateChannelCreate(PrivateChannelCreateEvent, ['PrivateChannel channel']),
  privateChannelUpdate(PrivateChannelUpdateEvent,
      ['PrivateChannel before', 'PrivateChannel after']),
  privateChannelDelete(PrivateChannelDeleteEvent, ['PrivateChannel? channel']),
  privateButtonClick(PrivateButtonClickEvent, ['PrivateButtonContext ctx']),
  privateDialogSubmit(PrivateDialogSubmitEvent, ['PrivateDialogContext ctx']),
  privateUserSelect(
      PrivateUserSelectEvent, ['PrivateSelectContext ctx', 'List<User> users']),
  privateTextSelect(PrivateTextSelectEvent,
      ['PrivateSelectContext ctx', 'List<String> values']);

  @override
  final Type value;

  final List<String> parameters;

  const Event(this.value, this.parameters);
}
