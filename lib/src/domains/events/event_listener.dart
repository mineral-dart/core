import 'dart:async';

import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';

abstract interface class EventListenerContract {
  Kernel get kernel;

  EventDispatcherContract get dispatcher;

  StreamSubscription listen<T extends Function>(
      {required Event event, required T handle, required String? customId});

  void dispose();
}

final class EventListener implements EventListenerContract {
  final List<StreamSubscription> _subscriptions = [];

  @override
  late final Kernel kernel;

  @override
  late final EventDispatcher dispatcher;

  EventListener() {
    dispatcher = EventDispatcher();
  }

  @override
  StreamSubscription listen<T extends Function>(
      {required Event event, required T handle, required String? customId}) {
    final controller = dispatcher.controllerFor(event);

    final subscription = controller.stream.where((element) {
      return switch (element.constraint) {
        final bool Function(String?) constraint => constraint(customId),
        _ => true
      };
    }).listen((element) async {
      try {
        await Function.apply(handle, element.params);
      } on Exception catch (e, stackTrace) {
        kernel.logger.error('Failed to dispatch event "${event.name}": $e');
        kernel.logger.trace('$stackTrace');
      } on Error catch (e, stackTrace) {
        kernel.logger.error('Failed to dispatch event "${event.name}": $e');
        kernel.logger.trace('$stackTrace');
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
