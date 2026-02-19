import 'dart:async';

import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

/// Tests the event listener mechanism using the underlying stream directly.
/// EventListener depends on Kernel (heavy), so we test the dispatch+listen
/// pattern through BehaviorSubject which is the core mechanism.
void main() {
  group('Event listener mechanism', () {
    late BehaviorSubject<InternalEventParams> subject;
    late EventDispatcher dispatcher;

    setUp(() {
      subject = BehaviorSubject();
      dispatcher = EventDispatcher(subject);
    });

    tearDown(() {
      if (!subject.isClosed) {
        subject.close();
      }
    });

    test('filters events by type', () async {
      final received = <Event>[];

      subject.stream
          .where((e) => e.event == Event.ready)
          .listen((e) => received.add(e.event));

      dispatcher
        ..dispatch(event: Event.ready, params: ['bot'])
        ..dispatch(event: Event.serverMessageCreate, params: ['msg'])
        ..dispatch(event: Event.ready, params: ['bot2']);

      await Future.delayed(Duration(milliseconds: 50));

      expect(received, hasLength(2));
      expect(received.every((e) => e == Event.ready), isTrue);
    });

    test('dispatches params to handler', () async {
      final receivedParams = <List>[];

      subject.stream
          .where((e) => e.event == Event.serverMemberAdd)
          .listen((e) => receivedParams.add(e.params));

      dispatcher.dispatch(
          event: Event.serverMemberAdd, params: ['server1', 'member1']);

      await Future.delayed(Duration(milliseconds: 50));

      expect(receivedParams, hasLength(1));
      expect(receivedParams.first[0], 'server1');
      expect(receivedParams.first[1], 'member1');
    });

    test('constraint filters on customId', () async {
      final received = <InternalEventParams>[];

      subject.stream
          .where((e) => e.event == Event.serverButtonClick)
          .where((e) {
        return switch (e.constraint) {
          final bool Function(String?) constraint => constraint('btn-save'),
          _ => true
        };
      }).listen(received.add);

      // This one matches the constraint
      dispatcher
        ..dispatch(
          event: Event.serverButtonClick,
          params: ['ctx1'],
          constraint: (id) => id == 'btn-save',
        )
        // This one does NOT match
        ..dispatch(
          event: Event.serverButtonClick,
          params: ['ctx2'],
          constraint: (id) => id == 'btn-delete',
        )
        // This one has no constraint (should pass)
        ..dispatch(
          event: Event.serverButtonClick,
          params: ['ctx3'],
        );

      await Future.delayed(Duration(milliseconds: 50));

      expect(received, hasLength(2));
      expect(received[0].params[0], 'ctx1');
      expect(received[1].params[0], 'ctx3');
    });

    test('does not receive events after subscription cancel', () async {
      final received = <Event>[];

      final sub = subject.stream
          .where((e) => e.event == Event.ready)
          .listen((e) => received.add(e.event));

      dispatcher.dispatch(event: Event.ready, params: ['bot']);
      await Future.delayed(Duration(milliseconds: 50));

      await sub.cancel();

      dispatcher.dispatch(event: Event.ready, params: ['bot2']);
      await Future.delayed(Duration(milliseconds: 50));

      expect(received, hasLength(1));
    });

    test('multiple listeners receive same event', () async {
      final listener1 = <Event>[];
      final listener2 = <Event>[];

      subject.stream
          .where((e) => e.event == Event.ready)
          .listen((e) => listener1.add(e.event));

      subject.stream
          .where((e) => e.event == Event.ready)
          .listen((e) => listener2.add(e.event));

      dispatcher.dispatch(event: Event.ready, params: ['bot']);

      await Future.delayed(Duration(milliseconds: 50));

      expect(listener1, hasLength(1));
      expect(listener2, hasLength(1));
    });

    test('different listeners on different events receive only their events',
        () async {
      final readyEvents = <Event>[];
      final messageEvents = <Event>[];

      subject.stream
          .where((e) => e.event == Event.ready)
          .listen((e) => readyEvents.add(e.event));

      subject.stream
          .where((e) => e.event == Event.serverMessageCreate)
          .listen((e) => messageEvents.add(e.event));

      dispatcher
        ..dispatch(event: Event.ready, params: ['bot'])
        ..dispatch(event: Event.serverMessageCreate, params: ['msg'])
        ..dispatch(event: Event.ready, params: ['bot']);

      await Future.delayed(Duration(milliseconds: 50));

      expect(readyEvents, hasLength(2));
      expect(messageEvents, hasLength(1));
    });
  });
}
