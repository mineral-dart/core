import 'package:mineral/api/common/types/enhanced_enum.dart';
import 'package:mineral/domains/events/contracts/private/private_message_delete_bulk_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_delete_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_add_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_remove_all_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_remove_emoji_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_reaction_remove_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_delete_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_reaction_add_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_reaction_remove_emoji_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_reaction_remove_event.dart';
import 'package:mineral/domains/events/contracts/common/ready_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_delete_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_channel_update_event.dart';
import 'package:mineral/domains/events/contracts/private/private_message_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_ban_add_event.dart';
import 'package:mineral/domains/events/contracts/server/server_ban_remove_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_delete_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_pins_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_delete_event.dart';
import 'package:mineral/domains/events/contracts/server/server_emojis_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_add_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_remove_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_delete_bulk_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_reaction_remove_all_event.dart';
import 'package:mineral/domains/events/contracts/server/server_message_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_presence_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_roles_create_event.dart';
import 'package:mineral/domains/events/contracts/server/server_roles_remove_event.dart';
import 'package:mineral/domains/events/contracts/server/server_roles_update_event.dart';
import 'package:mineral/domains/events/contracts/server/server_stickers_update_event.dart';
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
  serverMessageDeleteBulk(ServerMessageDeleteBulkEvent),
  serverMessageDelete(ServerMessageDeleteEvent),
  serverMessageReactionAdd(ServerMessageReactionAddEvent),
  serverMessageReactionRemoveAll(ServerMessageReactionRemoveAllEvent),
  serverMessageReactionRemove(ServerMessageReactionRemoveEvent),
  serverMessageReactionRemoveEmoji(ServerMessageReactionRemoveEmojiEvent),
  serverMessageUpdate(ServerMessageUpdateEvent),

  // private
  privateMessageCreate(PrivateMessageCreateEvent),
  privateChannelCreate(PrivateChannelCreateEvent),
  privateChannelUpdate(PrivateChannelUpdateEvent),
  privateChannelDelete(PrivateChannelDeleteEvent),
  privateMessageDelete(PrivateMessageDeleteEvent),
  privateMessageDeleteBulk(PrivateMessageDeleteBulkEvent),
  privateMessageReactionAdd(PrivateMessageReactionAddEvent),
  privateMessageReactionRemoveAll(PrivateMessageReactionRemoveAllEvent),
  privateMessageReactionRemove(PrivateMessageReactionRemoveEvent),
  privateMessageReactionRemoveEmoji(PrivateMessageReactionRemoveEmojiEvent),
  privateMessageUpdate(PrivateMessageUpdateEvent),

  ;

  @override
  final Type value;

  const Event(this.value);
}
