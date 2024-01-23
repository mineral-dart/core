import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/dispatchers/event_dispatcher.dart';
import 'package:mineral/domains/data/dispatchers/packet_dispatcher.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';

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
  final MemoryStorageContract storage;

  DataListener(this.logger, this.storage) {
    packets = PacketDispatcher(this, logger);
  }

  void subscribe(ListenablePacket Function(LoggerContract, MemoryStorageContract) factory) {
    final packet = factory(logger, storage);
    packets.listen(packet.event, packet.listen);
  }

  @override
  void dispose() {
    packets.dispose();
    events.dispose();
  }
}
