import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/dispatchers/event_dispatcher.dart';
import 'package:mineral/domains/data/dispatchers/packet_dispatcher.dart';
import 'package:mineral/domains/data/packets/channel_create_packet.dart';
import 'package:mineral/domains/data/packets/channel_update_packet.dart';
import 'package:mineral/domains/data/packets/guild_create_packet.dart';
import 'package:mineral/domains/data/packets/message_create_packet.dart';
import 'package:mineral/domains/data/packets/ready_packet.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

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
    subscribe(ChannelCreatePacket.new);
    subscribe(ChannelUpdatePacket.new);
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
