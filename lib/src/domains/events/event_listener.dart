import 'dart:async';

import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventListenerContract {
  Kernel get kernel;

  EventDispatcherContract get dispatcher;

  StreamSubscription listen<T extends Function>(
      {required Event event, required T handle, required String? customId});
}

final class EventListener implements EventListenerContract {
  final BehaviorSubject<InternalEventParams> _events = BehaviorSubject();

  @override
  late final Kernel kernel;

  @override
  late final EventDispatcherContract dispatcher;

  EventListener() {
    dispatcher = EventDispatcher(_events);
  }

  @override
  StreamSubscription listen<T extends Function>(
      {required Event event, required T handle, required String? customId}) {
    return _events.stream
        .where((element) => element.event == event)
        .where((element) {
      return switch (element.constraint) {
        final bool Function(String?) constraint => constraint(customId),
        _ => true
      };
    }).listen((element) => Function.apply(handle, element.params));
  }
}
