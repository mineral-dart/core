import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

typedef EventContainer<T> = Map<T, List<MineralEvent>>;

class EventWrapper {
  final Type event;
  final Event param;

  EventWrapper(this.event, this.param);
}

class EventManager {
  final EventContainer _events = {};
  final controller = StreamController<EventWrapper>();

  EventContainer get events => _events;

  void register (List<MineralEvent<Event>> events) {
    controller.stream.listen((listener) {
      final events = _events.getOrFail(listener.event);
      for (final event in events) {
        event.handle(listener.param);
      }
    });

    for (final event in events) {
      if (_events.containsKey(event.listener)) {
        _events.get(event.listener)?.add(event);
      } else {
        _events.putIfAbsent(event.listener, () => [event]);
      }
    }
  }

  void emit ({ required Events event, String? customId, List<dynamic>? params }) {
    /*List<Map<String, dynamic>>? events = _events.get(event);

    if (events != null) {
      for (Map<String, dynamic> event in events) {
        if (customId != null) {
          if (customId == event['customId']) {
            reflect(event['mineralEvent']).invoke(Symbol('handle'), params ?? []);
          }
        } else {
          if (event['customId'] == null) {
            reflect(event['mineralEvent']).invoke(Symbol('handle'), params ?? []);
          }
        }
      }
    }*/
  }
}
