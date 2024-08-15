import 'package:mineral/api/common/types/enhanced_enum.dart';
import 'package:mineral/domains/events/contracts/common/ready_event.dart';
import 'package:mineral/domains/events/contracts/private/private_button_click_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_delete_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_dialog_submit_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_text_select_event.dart';
import 'package:mineral/domains/events/contracts/private/private_user_select_event.dart';
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

interface class EventType {}

enum Event implements EnhancedEnum, EventType {
  ready(ReadyEvent),
  serverCreate(ServerCreateEvent),
  serverUpdate(ServerUpdateEvent),
  serverDelete(ServerDeleteEvent),
  serverMessageCreate(ServerMessageCreateEvent),
  serverChannelCreate(ServerChannelCreateEvent),
  serverChannelUpdate(ServerChannelUpdateEvent),
  serverChannelDelete(ServerChannelDeleteEvent),
  serverChannelPinsUpdate(ServerChannelPinsUpdateEvent),
  privateChannelPinsUpdate(PrivateChannelPinsUpdateEvent),
  serverMemberAdd(ServerMemberAddEvent),
  serverMemberRemove(ServerMemberRemoveEvent),
  serverBanAdd(ServerBanAddEvent),
  serverBanRemove(ServerBanRemoveEvent),
  serverMemberUpdate(ServerMemberUpdateEvent),
  serverPresenceUpdate(ServerPresenceUpdateEvent),
  serverEmojisUpdate(ServerEmojisUpdateEvent),
  serverStickersUpdate(ServerStickersUpdateEvent),
  serverRoleCreate(ServerRolesCreateEvent),
  serverRoleUpdate(ServerRolesUpdateEvent),
  serverRoleDelete(ServerRolesDeleteEvent),
  serverButtonClick(ServerButtonClickEvent),
  serverDialogSubmit(ServerDialogSubmitEvent),
  serverChannelSelect(ServerChannelSelectEvent),
  serverRoleSelect(ServerRoleSelectEvent),
  serverMemberSelect(ServerMemberSelectEvent),
  serverTextSelect(ServerTextSelectEvent),

  // private
  privateMessageCreate(PrivateMessageCreateEvent),
  privateChannelCreate(PrivateChannelCreateEvent),
  privateChannelUpdate(PrivateChannelUpdateEvent),
  privateChannelDelete(PrivateChannelDeleteEvent),
  privateButtonClick(PrivateButtonClickEvent),
  privateDialogSubmit(PrivateDialogSubmitEvent),
  privateUserSelect(PrivateUserSelectEvent),
  privateTextSelect(PrivateTextSelectEvent);

  @override
  final Type value;

  const Event(this.value);
}
