import 'package:mineral/domains/events/dispatchers/event_dispatcher.dart';
import 'package:mineral/domains/events/dispatchers/packet_dispatcher.dart';
import 'package:mineral/domains/events/packets/channel_create_packet.dart';
import 'package:mineral/domains/events/packets/channel_delete_packet.dart';
import 'package:mineral/domains/events/packets/channel_pins_update_packet.dart';
import 'package:mineral/domains/events/packets/channel_update_packet.dart';
import 'package:mineral/domains/events/packets/guild_ban_add_packet.dart';
import 'package:mineral/domains/events/packets/guild_ban_remove_packet.dart';
import 'package:mineral/domains/events/packets/guild_create_packet.dart';
import 'package:mineral/domains/events/packets/guild_delete_packet.dart';
import 'package:mineral/domains/events/packets/guild_emojis_update_packet.dart';
import 'package:mineral/domains/events/packets/guild_member_add_packet.dart';
import 'package:mineral/domains/events/packets/guild_member_chunk_packet.dart';
import 'package:mineral/domains/events/packets/guild_member_remove_packet.dart';
import 'package:mineral/domains/events/packets/guild_member_update_packet.dart';
import 'package:mineral/domains/events/packets/guild_role_create_packet.dart';
import 'package:mineral/domains/events/packets/guild_role_delete_packet.dart';
import 'package:mineral/domains/events/packets/guild_role_update_packet.dart';
import 'package:mineral/domains/events/packets/guild_stickers_update_packet.dart';
import 'package:mineral/domains/events/packets/guild_update_packet.dart';
import 'package:mineral/domains/events/packets/message_create_packet.dart';
import 'package:mineral/domains/events/packets/presence_update_packet.dart';
import 'package:mineral/domains/events/packets/ready_packet.dart';
import 'package:mineral/domains/events/types/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class DataListenerContract {
  PacketDispatcherContract get packets;

  EventDispatcherContract get events;

  void dispose();
}

final class DataListener implements DataListenerContract {
  @override
  late final PacketDispatcherContract packets;

  @override
  final EventDispatcherContract events = EventDispatcher();

  final LoggerContract logger;
  final MarshallerContract marshaller;

  DataListener(this.logger, this.marshaller) {
    packets = PacketDispatcher(this, logger);

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
  }

  void subscribe(ListenablePacket Function(LoggerContract, MarshallerContract) factory) {
    final packet = factory(logger, marshaller);
    packets.listen(packet.packetType, packet.listen);
  }

  @override
  void dispose() {
    packets.dispose();
    events.dispose();
  }
}
