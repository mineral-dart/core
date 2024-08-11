import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/channel_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/channel_delete_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/channel_pins_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/channel_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_ban_add_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_ban_remove_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_delete_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_emojis_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_member_add_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_member_chunk_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_member_remove_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_member_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_role_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_role_delete_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_role_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_stickers_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/guild_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/interactions/button_interaction_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/interactions/command_interaction_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/interactions/dialog_interaction_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/interactions/interaction_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/interactions/select_interaction_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/message_create_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/presence_update_packet.dart';
import 'package:mineral/infrastructure/internals/packets/listeners/ready_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_dispatcher.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class PacketListenerContract {
  PacketDispatcherContract get dispatcher;

  void dispose();
}

final class PacketListener implements PacketListenerContract {
  @override
  late final PacketDispatcherContract dispatcher;

  late final KernelContract kernel;

  void subscribe(ListenablePacket Function(LoggerContract, MarshallerContract) factory) {
    final packet = factory(kernel.logger, kernel.marshaller);
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

    subscribe(ButtonInteractionCreatePacket.new);
    subscribe(InteractionCreatePacket.new);
    subscribe(CommandInteractionCreatePacket.new);
    subscribe(SelectInteractionCreatePacket.new);
    subscribe(DialogInteractionCreatePacket.new);
  }
}
