import 'package:mineral/src/infrastructure/services/http/header.dart';
import 'package:test/test.dart';

void main() {
  group('Header', () {
    test('stores key and value', () {
      final header = Header('X-Custom', 'some-value');
      expect(header.key, 'X-Custom');
      expect(header.value, 'some-value');
    });

    group('factory constructors', () {
      test('contentType creates Content-Type header', () {
        final header = Header.contentType('application/json');
        expect(header.key, 'Content-Type');
        expect(header.value, 'application/json');
      });

      test('accept creates Accept header', () {
        final header = Header.accept('text/html');
        expect(header.key, 'Accept');
        expect(header.value, 'text/html');
      });

      test('authorization creates Authorization header', () {
        final header = Header.authorization('Bot my-token');
        expect(header.key, 'Authorization');
        expect(header.value, 'Bot my-token');
      });

      test('userAgent creates User-Agent header', () {
        final header = Header.userAgent('Mineral/4.2.0');
        expect(header.key, 'User-Agent');
        expect(header.value, 'Mineral/4.2.0');
      });
    });
  });
}
