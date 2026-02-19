import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:test/test.dart';

void main() {
  group('InternalEventParams', () {
    test('stores event, params, and constraint', () {
      bool constraint(String? id) => id == 'btn-1';

      final params = InternalEventParams(
        Event.ready,
        ['param1', 'param2'],
        constraint,
      );

      expect(params.event, Event.ready);
      expect(params.params, hasLength(2));
      expect(params.params[0], 'param1');
      expect(params.params[1], 'param2');
      expect(params.constraint, isNotNull);
      expect(params.constraint!('btn-1'), isTrue);
      expect(params.constraint!('btn-2'), isFalse);
    });

    test('constraint can be null', () {
      final params = InternalEventParams(
        Event.serverMessageCreate,
        ['message'],
        null,
      );

      expect(params.constraint, isNull);
    });

    test('params can be empty list', () {
      final params = InternalEventParams(Event.ready, [], null);
      expect(params.params, isEmpty);
    });

    test('works with different event types', () {
      final readyParams = InternalEventParams(Event.ready, ['bot'], null);
      final msgParams =
          InternalEventParams(Event.serverMessageCreate, ['msg'], null);
      final voiceParams = InternalEventParams(
          Event.voiceStateUpdate, ['before', 'after'], null);

      expect(readyParams.event, Event.ready);
      expect(msgParams.event, Event.serverMessageCreate);
      expect(voiceParams.event, Event.voiceStateUpdate);
      expect(voiceParams.params, hasLength(2));
    });
  });
}
