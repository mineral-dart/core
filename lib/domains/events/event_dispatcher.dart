import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/internal_event_params.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventDispatcherContract {
  void dispatch({required Event event, required List params});

  void dispose();
}

final class EventDispatcher implements EventDispatcherContract {
  final BehaviorSubject<InternalEventParams> _events;

  EventDispatcher(this._events);

  @override
  void dispatch({required Event event, required List params}) {
    _events.add(InternalEventParams(event, params));
  }

  @override
  void dispose() => _events.close();
}
