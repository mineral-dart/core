import 'dart:async';

import 'package:mineral/domains/events/internal_event.dart';
import 'package:mineral/domains/events/types/listenable_dispatcher.dart';
import 'package:rxdart/rxdart.dart';

final class EventDispatcher implements ListenableDispatcher {
  final BehaviorSubject<dynamic> _events = BehaviorSubject();

  @override
  StreamSubscription listen(dynamic payload) {
    if (payload is! InternalEvent) {
      throw Exception('Invalid event type');
    }

    return _events.stream.where((event) => event['event'] == payload.event)
      .listen((dynamic params) => payload.handle());
  }

  @override
  void dispatch(payload) => _events.add(payload);

  @override
  void dispose() => _events.close();
}
