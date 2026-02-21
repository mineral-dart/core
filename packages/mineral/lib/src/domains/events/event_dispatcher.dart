import 'dart:async';

import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';

abstract interface class EventDispatcherContract {
  void dispatch({required Event event, required List params});

  void dispose();
}

final class EventDispatcher implements EventDispatcherContract {
  final Map<Event, StreamController<InternalEventParams>> _controllers = {};

  StreamController<InternalEventParams> controllerFor(Event event) {
    return _controllers.putIfAbsent(
        event, StreamController<InternalEventParams>.broadcast);
  }

  @override
  void dispatch(
      {required Event event,
      required List params,
      bool Function(String?)? constraint}) {
    final controller = _controllers[event];
    if (controller != null && controller.hasListener) {
      controller.add(InternalEventParams(event, params, constraint));
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
