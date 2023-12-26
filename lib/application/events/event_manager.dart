import 'package:mineral/application/events/dispatchers/event_dispatcher.dart';
import 'package:mineral/application/events/dispatchers/packet_dispatcher.dart';
import 'package:mineral/application/events/types/listenable.dart';

abstract interface class EventManagerContract {
  Listenable get packets;
  Listenable get events;
  void dispose();
}

final class EventManager implements EventManagerContract {
  @override
  final PacketDispatcher packets = PacketDispatcher();

  @override
  final EventDispatcher events = EventDispatcher();

  @override
  void dispose() {
    packets.dispose();
    events.dispose();
  }
}
