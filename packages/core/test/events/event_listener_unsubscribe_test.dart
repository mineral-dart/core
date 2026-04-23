import 'dart:async';

import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:test/test.dart';

/// Tests for the unsubscribe mechanism on EventDispatcher streams.
/// EventListener.unsubscribe() cancels the subscription and removes it
/// from the internal list. We verify the cancellation behavior here.
void main() {
  group('EventDispatcher unsubscribe behavior', () {
    late EventDispatcher dispatcher;

    setUp(() {
      dispatcher = EventDispatcher();
    });

    tearDown(() {
      dispatcher.dispose();
    });

    test('canceling a subscription stops event delivery', () async {
      final received = <String>[];

      final sub = dispatcher
          .controllerFor(Event.ready)
          .stream
          .listen((e) => received.add('received'));

      dispatcher.dispatch(event: Event.ready, payload: 'bot1');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(received, hasLength(1));

      await sub.cancel();

      dispatcher.dispatch(event: Event.ready, payload: 'bot2');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(received, hasLength(1));
    });

    test('canceling one subscription does not affect others', () async {
      final listener1 = <String>[];
      final listener2 = <String>[];

      final sub1 = dispatcher
          .controllerFor(Event.ready)
          .stream
          .listen((e) => listener1.add('l1'));

      dispatcher
          .controllerFor(Event.ready)
          .stream
          .listen((e) => listener2.add('l2'));

      dispatcher.dispatch(event: Event.ready, payload: 'bot');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(listener1, hasLength(1));
      expect(listener2, hasLength(1));

      await sub1.cancel();

      dispatcher.dispatch(event: Event.ready, payload: 'bot');
      await Future.delayed(const Duration(milliseconds: 50));
      expect(listener1, hasLength(1));
      expect(listener2, hasLength(2));
    });

    test('dispose closes all controllers', () {
      final controller = dispatcher.controllerFor(Event.ready);
      expect(controller.isClosed, isFalse);

      dispatcher.dispose();
      expect(controller.isClosed, isTrue);
    });
  });
}
