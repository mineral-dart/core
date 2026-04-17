import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:test/test.dart';

void main() {
  group('EventDispatcher', () {
    late EventDispatcher dispatcher;

    setUp(() {
      dispatcher = EventDispatcher();
    });

    tearDown(() {
      dispatcher.dispose();
    });

    test('dispatch adds event to the stream', () async {
      final received = <InternalEventParams>[];

      dispatcher.controllerFor(Event.ready).stream.listen(received.add);

      dispatcher.dispatch(event: Event.ready, params: ['bot']);

      await Future.delayed(Duration(milliseconds: 50));

      expect(received, hasLength(1));
      expect(received.first.event, Event.ready);
      expect(received.first.params, ['bot']);
      expect(received.first.constraint, isNull);
    });

    test('dispatch propagates constraint', () async {
      bool myConstraint(String? id) => id == 'test';

      final received = <InternalEventParams>[];

      dispatcher
          .controllerFor(Event.serverButtonClick)
          .stream
          .listen(received.add);

      dispatcher.dispatch(
        event: Event.serverButtonClick,
        params: ['ctx'],
        constraint: myConstraint,
      );

      await Future.delayed(Duration(milliseconds: 50));

      expect(received, hasLength(1));
      expect(received.first.constraint, isNotNull);
      expect(received.first.constraint!('test'), isTrue);
      expect(received.first.constraint!('other'), isFalse);
    });

    test('dispatch emits multiple events in order', () async {
      final events = <Event>[];

      dispatcher
          .controllerFor(Event.ready)
          .stream
          .listen((e) => events.add(e.event));
      dispatcher
          .controllerFor(Event.serverMessageCreate)
          .stream
          .listen((e) => events.add(e.event));
      dispatcher
          .controllerFor(Event.serverMemberAdd)
          .stream
          .listen((e) => events.add(e.event));

      dispatcher
        ..dispatch(event: Event.ready, params: ['bot'])
        ..dispatch(event: Event.serverMessageCreate, params: ['msg'])
        ..dispatch(event: Event.serverMemberAdd, params: ['server', 'member']);

      await Future.delayed(Duration(milliseconds: 50));

      expect(events, hasLength(3));
      expect(events[0], Event.ready);
      expect(events[1], Event.serverMessageCreate);
      expect(events[2], Event.serverMemberAdd);
    });

    test('dispose closes all streams', () {
      final controller = dispatcher.controllerFor(Event.ready);
      dispatcher.dispose();
      expect(controller.isClosed, isTrue);
    });

    test('dispatch with empty params', () async {
      final received = <InternalEventParams>[];

      dispatcher.controllerFor(Event.ready).stream.listen(received.add);

      dispatcher.dispatch(event: Event.ready, params: []);

      await Future.delayed(Duration(milliseconds: 50));

      expect(received, hasLength(1));
      expect(received.first.params, isEmpty);
    });
  });
}
