import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class EventManager {
  final Map<Events, List<Map<String, dynamic>>> _events = {};

  Map<Events, List<Map<String, dynamic>>> getRegisteredEvents () => _events;

  EventManager add (MineralEvent mineralEvent) {
    Event eventDecorator = reflect(mineralEvent).type.metadata.first.reflectee;
    Events event = eventDecorator.event;
    String? customId = eventDecorator.customId;

    Map<String, dynamic> eventEntity = {
      'mineralEvent': mineralEvent,
      'customId': customId,
    };

    if (_events.containsKey(event)) {
      List<Map<String, dynamic>>? events = _events.get(event);
      events?.add(eventEntity);
    } else {
      _events.putIfAbsent(event, () => [eventEntity]);
    }

    return this;
  }

  void emit ({ required Events event, String? customId, List<dynamic>? params }) {
    List<Map<String, dynamic>>? events = _events.get(event);

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
    }
  }
}
