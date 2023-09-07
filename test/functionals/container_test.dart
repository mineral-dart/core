import 'package:mineral/internal/fold/container.dart';
import 'package:mineral/internal/fold/injectable.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class Foo extends Injectable {
  String name = 'foo';
}

class Bar extends Injectable {
  Foo foo;
  Bar(this.foo);
}

void main () {
  test('can insert injectable', () {
    final container = Container();

    expect(container.bind('foo', (container) => Foo()), isA<Foo>());
    expect(container.length(), 1);
  });

  test('can insert injectable related another one', () {
    final container = Container();

    container.bind('foo', (container) => Foo());
    container.bind('bar', (container) => Bar(container.use('foo')));

    expect(container.length(), 2);
    expect(container.use<Bar>('bar'), isA<Bar>());
    expect(container.use<Bar>('bar').foo, isA<Foo>());
  });

  test('can remove injectable', () {
    final container = Container();

    container.bind('foo', (container) => Foo());
    container.remove('foo');

    expect(container.length(), isZero);
  });
}