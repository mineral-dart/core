import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

typedef EventContainer<T> = Map<T, List<MineralEvent>>;

class EventService extends MineralService {
  final EventContainer _events = {};
  final StreamController<Event> controller = StreamController();

  EventContainer get events => _events;

  EventService(): super(inject: true) {
    controller.stream.listen((_event) {
      final regexp = RegExp(r'^([a-zA-Z0-9_]+)<.*>$|^([a-zA-Z0-9_]+)$');
      final match = regexp.firstMatch(_event.runtimeType.toString());
      final eventType = match?.group(1) ?? match?.group(2);

      final events = _events.entries.firstWhereOrNull((event) => event.key.toString().startsWith(eventType.toString()));
      if (events != null) {
        for (final event in events.value) {
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
        print(event.listener);
        _events.putIfAbsent(event.listener, () => [event]);
      }
    }
  }
}
