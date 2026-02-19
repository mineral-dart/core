import 'dart:async';

import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventListenerContract {
  Kernel get kernel;

  EventDispatcherContract get dispatcher;

  StreamSubscription listen<T extends Function>(
      {required Event event, required T handle, required String? customId});

  void dispose();
}

final class EventListener implements EventListenerContract {
  final BehaviorSubject<InternalEventParams> _events = BehaviorSubject();
  final List<StreamSubscription> _subscriptions = [];

  @override
  late final Kernel kernel;

  @override
  late final EventDispatcherContract dispatcher;

  EventListener() {
    dispatcher = EventDispatcher(_events);
  }

  @override
  StreamSubscription listen<T extends Function>(
      {required Event event, required T handle, required String? customId}) {
    final subscription = _events.stream
        .where((element) => element.event == event)
        .where((element) {
      return switch (element.constraint) {
        final bool Function(String?) constraint => constraint(customId),
        _ => true
      };
    }).listen((element) {
      try {
        Function.apply(handle, element.params);
      } on Exception catch (e) {
        kernel.logger.error('Failed to dispatch event "${event.name}": $e');
      }
    });

    _subscriptions.add(subscription);
    return subscription;
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    dispatcher.dispose();
  }
}
