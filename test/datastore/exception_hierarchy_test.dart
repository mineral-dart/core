import 'package:mineral/api.dart';
import 'package:test/test.dart';

void main() {
  group('MineralException hierarchy', () {
    test('HttpStatusException contains status code and body', () {
      final exception = HttpStatusException(404, 'Not Found');
      expect(exception.statusCode, equals(404));
      expect(exception.body, equals('Not Found'));
      expect(exception.message, contains('404'));
      expect(exception.toString(), contains('HttpStatusException'));
    });

    test('SerializationException contains descriptive message', () {
      final exception =
          SerializationException('Expected ServerTextChannel but got Message');
      expect(exception.message, contains('ServerTextChannel'));
      expect(exception.toString(), contains('SerializationException'));
    });

    test('ServiceNotFoundException contains service type', () {
      final exception = ServiceNotFoundException(String);
      expect(exception.serviceType, equals(String));
      expect(exception.message, contains('String'));
      expect(exception.toString(), contains('ServiceNotFoundException'));
    });

    test('InvalidCommandException contains descriptive message', () {
      final exception = InvalidCommandException('Command /hello already exists');
      expect(exception.message, contains('/hello'));
      expect(exception.toString(), contains('InvalidCommandException'));
    });

    test('InvalidComponentException contains descriptive message', () {
      final exception =
          InvalidComponentException('Component "my-button" not found');
      expect(exception.message, contains('my-button'));
      expect(exception.toString(), contains('InvalidComponentException'));
    });

    test('all exceptions implement MineralException', () {
      expect(HttpStatusException(500, ''), isA<MineralException>());
      expect(SerializationException(''), isA<MineralException>());
      expect(ServiceNotFoundException(String), isA<MineralException>());
      expect(InvalidCommandException(''), isA<MineralException>());
      expect(InvalidComponentException(''), isA<MineralException>());
    });

    test('all exceptions implement Exception', () {
      expect(HttpStatusException(500, ''), isA<Exception>());
      expect(SerializationException(''), isA<Exception>());
      expect(ServiceNotFoundException(String), isA<Exception>());
      expect(InvalidCommandException(''), isA<Exception>());
      expect(InvalidComponentException(''), isA<Exception>());
    });
  });
}
