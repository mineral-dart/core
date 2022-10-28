import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

typedef EventContainer<T> = Map<T, List<MineralEvent>>;

class EventManager {
  final EventContainer _events = {};
  final controller = StreamController<Event>();

  EventContainer get events => _events;

  EventManager() {
    controller.stream.listen((_event) {
      final events = _events.get(_event.runtimeType);
      if (events != null) {
        for (final event in events) {
          event.handle(_event);
        }
      }
    });
  }

  void register (List<MineralEvent<Event>> events) {
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
