import 'dart:async';

import 'package:mineral/domains/data/internal_event.dart';
import 'package:mineral/domains/data/internal_event_params.dart';
import 'package:mineral/domains/data/types/listenable_dispatcher.dart';
import 'package:rxdart/rxdart.dart';

final class EventDispatcher implements ListenableDispatcher<InternalEventParams> {
  final BehaviorSubject<InternalEventParams> _events = BehaviorSubject();

  @override
  StreamSubscription listen(dynamic payload) {
    if (payload is! InternalEvent) {
      throw Exception('payload must be an instance of InternalEvent');
    }

    return _events.stream.where((message) => message.event == payload.event)
      .listen((message) => Function.apply(payload.handle, message.params));
  }

  @override
  void dispatch(InternalEventParams payload) {
    _events.add(payload);
  }

  @override
  void dispose() => _events.close();
}
