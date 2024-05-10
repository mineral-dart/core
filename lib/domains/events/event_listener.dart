import 'dart:async';

import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/event_dispatcher.dart';
import 'package:mineral/domains/events/internal_event_params.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventListenerContract {
  KernelContract get kernel;

  EventDispatcherContract get dispatcher;

  StreamSubscription listen<T extends Function>({required Event event, required T handle});
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
  StreamSubscription listen<T extends Function>({required Event event, required T handle}) {
    return _events.stream
        .where((element) => element.event == event)
        .listen((element) => Function.apply(handle, element.params));
  }
}
