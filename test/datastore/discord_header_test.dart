import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:test/test.dart';

void main() {
  group('DiscordHeader', () {
    test('stores key and value', () {
      final header = DiscordHeader('X-Custom', 'some-value');
      expect(header.key, 'X-Custom');
      expect(header.value, 'some-value');
    });

    group('factory constructors', () {
      test('contentType creates Content-Type header', () {
        final header = DiscordHeader.contentType('application/json');
        expect(header.key, 'Content-Type');
        expect(header.value, 'application/json');
      });

      test('accept creates Accept header', () {
        final header = DiscordHeader.accept('text/html');
        expect(header.key, 'Accept');
        expect(header.value, 'text/html');
      });

      test('authorization creates Authorization header', () {
        final header = DiscordHeader.authorization('Bot my-token');
        expect(header.key, 'Authorization');
        expect(header.value, 'Bot my-token');
      });

      test('userAgent creates User-Agent header', () {
        final header = DiscordHeader.userAgent('Mineral/4.2.0');
        expect(header.key, 'User-Agent');
        expect(header.value, 'Mineral/4.2.0');
      });
    });

    group('auditLogReason', () {
      test('creates X-Audit-Log-Reason header', () {
        final header = DiscordHeader.auditLogReason('test reason');
        expect(header.key, 'X-Audit-Log-Reason');
      });

      test('encodes reason with Uri.encodeComponent', () {
        final header = DiscordHeader.auditLogReason('ban reason');
        expect(header.value, Uri.encodeComponent('ban reason'));
      });

      test('encodes special characters', () {
        final header = DiscordHeader.auditLogReason('raison: spéciale & ça');
        expect(header.value, Uri.encodeComponent('raison: spéciale & ça'));
      });

      test('handles null value as empty string', () {
        final header = DiscordHeader.auditLogReason(null);
        expect(header.value, Uri.encodeComponent(''));
        expect(header.value, isEmpty);
      });

      test('handles empty string', () {
        final header = DiscordHeader.auditLogReason('');
        expect(header.value, isEmpty);
      });

      test('encodes spaces', () {
        final header = DiscordHeader.auditLogReason('reason with spaces');
        expect(header.value, contains('reason'));
        expect(header.value, isNot(contains(' ')));
      });
    });

    group('implements Header interface', () {
      test('key is accessible', () {
        final header = DiscordHeader('Test', 'value');
        expect(header.key, isA<String>());
      });

      test('value is accessible', () {
        final header = DiscordHeader('Test', 'value');
        expect(header.value, isA<String>());
      });
    });
  });
}
