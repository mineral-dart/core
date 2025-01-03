import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/commons/kernel.dart';
import 'package:mineral/src/domains/contracts/packets/packet_dispatcher.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/channel_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/channel_delete_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/channel_pins_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/channel_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_audit_log_entry_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_ban_add_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_ban_remove_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_delete_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_emojis_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_member_add_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_member_chunk_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_member_remove_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_member_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_role_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_role_delete_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_role_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_stickers_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/guild_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/interactions/button_interaction_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/interactions/command_interaction_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/interactions/dialog_interaction_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/interactions/interaction_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/interactions/select_interaction_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/message_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/presence_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/ready_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/thread_create_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/thread_delete_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/thread_members_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/listeners/thread_update_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_dispatcher.dart';

final class PacketListener implements PacketListenerContract {
  @override
  late final PacketDispatcherContract dispatcher;

  late final KernelContract kernel;

  void subscribe(ListenablePacket Function() factory) {
    final packet = factory();
    dispatcher.listen(packet.packetType, packet.listen);
  }

  @override
  void dispose() {
    dispatcher.dispose();
  }

  void init() {
    dispatcher = PacketDispatcher(kernel);

    subscribe(ReadyPacket.new);
    subscribe(MessageCreatePacket.new);
    subscribe(GuildCreatePacket.new);
    subscribe(GuildUpdatePacket.new);
    subscribe(GuildDeletePacket.new);
    subscribe(ChannelCreatePacket.new);
    subscribe(ChannelUpdatePacket.new);
    subscribe(ChannelDeletePacket.new);
    subscribe(ChannelPinsUpdatePacket.new);
    subscribe(GuildMemberAddPacket.new);
    subscribe(GuildMemberRemovePacket.new);
    subscribe(GuildMemberUpdatePacket.new);
    subscribe(GuildRoleCreatePacket.new);
    subscribe(GuildRoleUpdatePacket.new);
    subscribe(GuildRoleDeletePacket.new);
    subscribe(GuildMemberChunkPacket.new);
    subscribe(PresenceUpdatePacket.new);
    subscribe(GuildBanAddPacket.new);
    subscribe(GuildBanRemovePacket.new);
    subscribe(GuildEmojisUpdatePacket.new);
    subscribe(GuildStickersUpdatePacket.new);
    subscribe(GuildAuditLogEntryCreatePacket.new);

    subscribe(ButtonInteractionCreatePacket.new);
    subscribe(InteractionCreatePacket.new);
    subscribe(CommandInteractionCreatePacket.new);
    subscribe(SelectInteractionCreatePacket.new);
    subscribe(DialogInteractionCreatePacket.new);

    subscribe(ThreadCreatePacket.new);
    subscribe(ThreadUpdatePacket.new);
    subscribe(ThreadDeletePacket.new);
    subscribe(ThreadMembersUpdatePacket.new);
  }
}
