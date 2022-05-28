import 'dart:mirrors';

import 'package:mineral/core.dart';

class EventManager {
  final Collection<EventList, List<Object>> _events = Collection();

  EventManager add (Object object) {
    EventList event = reflect(object).type.metadata.first.reflectee.event;

    if (_events.containsKey(event)) {
      List<Object>? events = _events.get(event);
      events?.add(object);
    } else {
      _events.putIfAbsent(event, () => [object]);
    }

    return this;
  }

  emit (EventList event,  [params]) {
    List<Object>? events = _events.get(event);

    if (events != null) {
      for (Object event in events) {
        reflect(event).invoke(Symbol('handle'), params);
      }
    }
  }
}
