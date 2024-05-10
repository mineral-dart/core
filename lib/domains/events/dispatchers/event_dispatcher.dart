import 'package:mineral/domains/events/internal_event_params.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventDispatcherContract {
  void dispatch({required EventList event, required List params});

  void dispose();
}

final class EventDispatcher implements EventDispatcherContract {
  final BehaviorSubject<InternalEventParams> _events;

  EventDispatcher(this._events);

  @override
  void dispatch({required EventList event, required List params}) {
    _events.add(InternalEventParams(event.name, params));
  }

  @override
  void dispose() => _events.close();
}
