import 'dart:async';

import 'package:mineral/domains/events/event_dispatcher.dart';
import 'package:mineral/domains/events/internal_event_params.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventListenerContract {
  KernelContract get kernel;

  EventDispatcherContract get dispatcher;

  StreamSubscription listen({required EventList event, required Function handle});
}

final class EventListener implements EventListenerContract {
  final BehaviorSubject<InternalEventParams> _events = BehaviorSubject();

  @override
  late final KernelContract kernel;

  @override
  late final EventDispatcherContract dispatcher;

  EventListener() {
    dispatcher = EventDispatcher(_events);
  }

  @override
  StreamSubscription listen({required EventList event, required Function handle}) {
    return _events.stream
        .where((message) => message.event == event.name)
        .listen((message) => Function.apply(handle, message.params));
  }
}
