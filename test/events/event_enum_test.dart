import 'package:mineral/src/domains/events/event.dart';
import 'package:test/test.dart';

void main() {
  group('Event enum', () {
    test('has at least 60 event types', () {
      expect(Event.values.length, greaterThanOrEqualTo(60));
    });

    test('every event has a non-null value type', () {
      for (final event in Event.values) {
        expect(event.value, isNotNull,
            reason: '${event.name} should have a value type');
      }
    });

    test('every event has a non-empty parameters list', () {
      for (final event in Event.values) {
        expect(event.parameters, isNotEmpty,
            reason: '${event.name} should have at least one parameter');
      }
    });

    test('every parameter has format [type, name]', () {
      for (final event in Event.values) {
        for (final param in event.parameters) {
          expect(param, hasLength(2),
              reason:
                  '${event.name} parameter should have [type, name] format');
          expect(param[0], isA<String>(),
              reason: '${event.name} parameter type should be a String');
          expect(param[1], isA<String>(),
              reason: '${event.name} parameter name should be a String');
          expect(param[0], isNotEmpty,
              reason: '${event.name} parameter type should not be empty');
          expect(param[1], isNotEmpty,
              reason: '${event.name} parameter name should not be empty');
        }
      }
    });

    group('specific events', () {
      test('ready event has Bot parameter', () {
        expect(Event.ready.parameters[0][0], 'Bot');
        expect(Event.ready.parameters[0][1], 'bot');
      });

      test('serverMessageCreate has ServerMessage parameter', () {
        expect(Event.serverMessageCreate.parameters[0][0], 'ServerMessage');
        expect(Event.serverMessageCreate.parameters[0][1], 'message');
      });

      test('privateMessageCreate has PrivateMessage parameter', () {
        expect(Event.privateMessageCreate.parameters[0][0], 'PrivateMessage');
        expect(Event.privateMessageCreate.parameters[0][1], 'message');
      });

      test('serverMemberAdd has Server and Member parameters', () {
        expect(Event.serverMemberAdd.parameters, hasLength(2));
        expect(Event.serverMemberAdd.parameters[0][0], 'Server');
        expect(Event.serverMemberAdd.parameters[1][0], 'Member');
      });

      test('voiceStateUpdate has before and after VoiceState parameters', () {
        expect(Event.voiceStateUpdate.parameters, hasLength(2));
        expect(Event.voiceStateUpdate.parameters[0][1], 'before');
        expect(Event.voiceStateUpdate.parameters[1][1], 'after');
      });

      test('serverUpdate has before and after Server parameters', () {
        expect(Event.serverUpdate.parameters, hasLength(2));
        expect(Event.serverUpdate.parameters[0][0], 'Server');
        expect(Event.serverUpdate.parameters[0][1], 'before');
        expect(Event.serverUpdate.parameters[1][0], 'Server');
        expect(Event.serverUpdate.parameters[1][1], 'after');
      });

      test('serverButtonClick has ServerButtonContext parameter', () {
        expect(Event.serverButtonClick.parameters[0][0], 'ServerButtonContext');
        expect(Event.serverButtonClick.parameters[0][1], 'ctx');
      });

      test('serverModalSubmit has ServerModalContext parameter', () {
        expect(Event.serverModalSubmit.parameters[0][0], 'ServerModalContext');
        expect(Event.serverModalSubmit.parameters[0][1], 'ctx');
      });
    });

    group('event categories', () {
      test('server events exist', () {
        final serverEvents =
            Event.values.where((e) => e.name.startsWith('server'));
        expect(serverEvents.length, greaterThanOrEqualTo(40));
      });

      test('private events exist', () {
        final privateEvents =
            Event.values.where((e) => e.name.startsWith('private'));
        expect(privateEvents.length, greaterThanOrEqualTo(10));
      });

      test('voice events exist', () {
        final voiceEvents =
            Event.values.where((e) => e.name.startsWith('voice'));
        expect(voiceEvents.length, greaterThanOrEqualTo(4));
      });

      test('common events exist', () {
        expect(Event.values.contains(Event.ready), isTrue);
        expect(Event.values.contains(Event.typing), isTrue);
        expect(Event.values.contains(Event.inviteCreate), isTrue);
        expect(Event.values.contains(Event.inviteDelete), isTrue);
      });
    });

    group('all event names are unique', () {
      test('no duplicate event names', () {
        final names = Event.values.map((e) => e.name).toSet();
        expect(names.length, Event.values.length);
      });
    });
  });
}
