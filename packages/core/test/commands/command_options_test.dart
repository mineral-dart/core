import 'package:mineral/src/domains/commands/command_options.dart';
import 'package:test/test.dart';

void main() {
  group('CommandOptions', () {
    group('get', () {
      test('returns typed value', () {
        final options = CommandOptions({'name': 'Alice', 'count': 42});
        expect(options.get<String>('name'), 'Alice');
        expect(options.get<int>('count'), 42);
      });

      test('returns null for missing key', () {
        final options = CommandOptions({'name': 'Alice'});
        expect(options.get<String>('missing'), isNull);
      });

      test('throws ArgumentError for wrong type', () {
        final options = CommandOptions({'name': 42});
        expect(
          () => options.get<String>('name'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('require', () {
      test('returns typed value', () {
        final options = CommandOptions({'name': 'Alice'});
        expect(options.require<String>('name'), 'Alice');
      });

      test('throws ArgumentError for missing key', () {
        final options = CommandOptions({});
        expect(
          () => options.require<String>('name'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for wrong type', () {
        final options = CommandOptions({'name': 42});
        expect(
          () => options.require<String>('name'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('has', () {
      test('returns true for existing key', () {
        final options = CommandOptions({'name': 'Alice'});
        expect(options.has('name'), isTrue);
      });

      test('returns false for missing key', () {
        final options = CommandOptions({});
        expect(options.has('name'), isFalse);
      });
    });

    group('toMap', () {
      test('returns unmodifiable view', () {
        final options = CommandOptions({'name': 'Alice'});
        final map = options.toMap();
        expect(map['name'], 'Alice');
        expect(() => map['new'] = 'value', throwsA(isA<UnsupportedError>()));
      });
    });

    group('toString', () {
      test('includes values', () {
        final options = CommandOptions({'name': 'Alice'});
        expect(options.toString(), contains('name'));
        expect(options.toString(), contains('Alice'));
      });
    });
  });
}
