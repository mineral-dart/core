import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:test/test.dart';

abstract interface class AbstractClass {}

final class FooWithoutAbstract {}

final class Foo implements AbstractClass {}

final class Bar implements AbstractClass {}

void main() {
  group('service ioc', () {
    final ioc = IocContainer();

    tearDown(ioc.dispose);

    test('can bind service with concrete type', () {
      ioc.bind(Foo.new);
      expect(ioc.resolve<Foo>(), isA<Foo>());
    });

    test('can bind service with concrete type in generic', () {
      ioc.bind<Foo>(Foo.new);
      expect(ioc.resolve<Foo>(), isA<Foo>());
    });

    test('can bind service with abstract type', () {
      ioc.bind<AbstractClass>(Foo.new);
      expect(ioc.resolve<AbstractClass>(), isA<Foo>());
    });

    test('can override service', () {
      ioc.bind<AbstractClass>(Foo.new);
      expect(ioc.resolve<AbstractClass>(), isA<Foo>());

      ioc.override(AbstractClass, Bar.new);
      expect(ioc.resolve<AbstractClass>(), isA<Bar>());
    });

    test('cannot override a non-existent service', () {
      expect(() => ioc.override(AbstractClass, Bar.new), throwsException);
    });

    test('can override service then restore it', () {
      ioc
        ..bind<AbstractClass>(Foo.new)
        ..override(AbstractClass, Bar.new)
        ..restore(AbstractClass);

      expect(ioc.resolve<AbstractClass>(), isA<Foo>());
    });
  });
}
