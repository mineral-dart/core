import 'package:mineral/services/env/environment.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main () {
  test('can create environment', () {
    final Environment env = Environment();
    expect(env, isA<Environment>());
  });

  test('can set variable into environment', () {
    final key = 'foo';
    final value = 'bar';
    
    final Environment env = Environment();
    env.set(key, value);

    expect(env.get(key), allOf([
      isA<String>(),
      equals(value)
    ]));
  });

  test('can get not defined nullable variable from environment', () {
    final key = 'foo';
    final Environment env = Environment();

    expect(env.get(key), isNull);
  });

  test("can't get nullable variable from environment", () {
    final Environment env = Environment();
    expect(() => env.getOrFail('foo'), allOf([
      throwsException,
      throwsA(isA<Exception>())
    ]));
  });

  test("can't get nullable variable with message from environment", () {
    final String message = 'Foo not found';

    final Environment env = Environment();
    expect(() => env.getOrFail('foo', message: message), allOf([
      throwsException,
      throwsA(isA<Exception>()),
    ]));
  });

  test('can remove one environment variable', () {
    final key = 'foo';
    final Environment env = Environment();

    env.set(key, 'bar');
    expect(env.get(key), isNotNull);
    
    env.remove(key);
    expect(env.get(key), isNull);
  });
}