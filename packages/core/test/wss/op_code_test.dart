import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:test/test.dart';

void main() {
  group('OpCode', () {
    test('dispatch has value 0', () {
      expect(OpCode.dispatch.value, 0);
    });

    test('heartbeat has value 1', () {
      expect(OpCode.heartbeat.value, 1);
    });

    test('identify has value 2', () {
      expect(OpCode.identify.value, 2);
    });

    test('presenceUpdate has value 3', () {
      expect(OpCode.presenceUpdate.value, 3);
    });

    test('voiceStateUpdate has value 4', () {
      expect(OpCode.voiceStateUpdate.value, 4);
    });

    test('voiceGuildPing has value 5', () {
      expect(OpCode.voiceGuildPing.value, 5);
    });

    test('resume has value 6', () {
      expect(OpCode.resume.value, 6);
    });

    test('reconnect has value 7', () {
      expect(OpCode.reconnect.value, 7);
    });

    test('requestGuildMember has value 8', () {
      expect(OpCode.requestGuildMember.value, 8);
    });

    test('invalidSession has value 9', () {
      expect(OpCode.invalidSession.value, 9);
    });

    test('hello has value 10', () {
      expect(OpCode.hello.value, 10);
    });

    test('heartbeatAck has value 11', () {
      expect(OpCode.heartbeatAck.value, 11);
    });

    test('guildSync has value 12', () {
      expect(OpCode.guildSync.value, 12);
    });

    test('unknown has value -1', () {
      expect(OpCode.unknown.value, -1);
    });

    test('has 14 values total', () {
      expect(OpCode.values, hasLength(14));
    });

    test('all values have unique int values', () {
      final values = OpCode.values.map((e) => e.value).toSet();
      expect(values, hasLength(OpCode.values.length));
    });

    test('all standard Discord opcodes (0-12) are present', () {
      for (int i = 0; i <= 12; i++) {
        final found = OpCode.values.any((op) => op.value == i);
        expect(found, isTrue, reason: 'OpCode with value $i should exist');
      }
    });
  });
}
