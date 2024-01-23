import 'dart:async';

import 'package:mineral/domains/data/internal_event_params.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventDispatcherContract {
  StreamSubscription listen({required EventList event, required Function handle});

  void dispatch({required EventList event, required List params});

  void dispose();
}

final class EventDispatcher implements EventDispatcherContract {
  final BehaviorSubject<InternalEventParams> _events = BehaviorSubject();

  @override
  StreamSubscription listen({required EventList event, required Function handle}) {
    return _events.stream
        .where((message) => message.event == event.name)
        .listen((message) => Function.apply(handle, message.params));
  }

  @override
  void dispatch({required EventList event, required List params}) {
    _events.add(InternalEventParams(event.name, params));
  }

  @override
  void dispose() => _events.close();
}
