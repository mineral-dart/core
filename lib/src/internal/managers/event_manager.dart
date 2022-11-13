import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

typedef EventContainer<T> = Map<T, List<MineralEvent>>;

class EventManager {
  final EventContainer _events = {};
  final StreamController<Event> controller = StreamController();

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

  void register (List<MineralEvent> events) {
    for (final event in events) {
      if (_events.containsKey(event.listener)) {
        _events.get(event.listener)?.add(event);
      } else {
        _events.putIfAbsent(event.listener, () => [event]);
      }
    }
  }
}
