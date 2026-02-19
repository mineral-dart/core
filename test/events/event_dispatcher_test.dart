import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  group('EventDispatcher', () {
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

    test('dispatch adds event to the stream', () async {
      dispatcher.dispatch(event: Event.ready, params: ['bot']);

      final emitted = await subject.stream.first;
      expect(emitted.event, Event.ready);
      expect(emitted.params, ['bot']);
      expect(emitted.constraint, isNull);
    });

    test('dispatch propagates constraint', () async {
      bool myConstraint(String? id) => id == 'test';

      dispatcher.dispatch(
        event: Event.serverButtonClick,
        params: ['ctx'],
        constraint: myConstraint,
      );

      final emitted = await subject.stream.first;
      expect(emitted.constraint, isNotNull);
      expect(emitted.constraint!('test'), isTrue);
      expect(emitted.constraint!('other'), isFalse);
    });

    test('dispatch emits multiple events in order', () async {
      final events = <Event>[];
      subject.listen((e) => events.add(e.event));

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

    test('dispose closes the stream', () {
      dispatcher.dispose();
      expect(subject.isClosed, isTrue);
    });

    test('dispatch with empty params', () async {
      dispatcher.dispatch(event: Event.ready, params: []);

      final emitted = await subject.stream.first;
      expect(emitted.params, isEmpty);
    });
  });
}
