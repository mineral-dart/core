import 'package:mineral/application/events/dispatchers/event_dispatcher.dart';
import 'package:mineral/application/events/dispatchers/payload_dispatcher.dart';
import 'package:mineral/application/events/types/listenable.dart';

abstract interface class EventManagerContract {
  Listenable get payloads;
  Listenable get events;
  void dispose();
}

final class EventManager implements EventManagerContract {
  @override
  final PayloadDispatcher payloads = PayloadDispatcher();

  @override
  final EventDispatcher events = EventDispatcher();

  @override
  void dispose() {
    payloads.dispose();
    events.dispose();
  }
}
