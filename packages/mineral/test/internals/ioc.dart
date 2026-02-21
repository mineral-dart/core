import 'package:mineral/container.dart';
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

      ioc.override<AbstractClass>(Bar.new);
      expect(ioc.resolve<AbstractClass>(), isA<Bar>());
    });

    test('cannot override a non-existent service', () {
      expect(() => ioc.override<AbstractClass>(Bar.new), throwsException);
    });

    test('can override service then restore it', () {
      ioc
        ..bind<AbstractClass>(Foo.new)
        ..override<AbstractClass>(Bar.new)
        ..restore<AbstractClass>();

      expect(ioc.resolve<AbstractClass>(), isA<Foo>());
    });
  });

  group('resolve type safety', () {
    final ioc = IocContainer();

    tearDown(ioc.dispose);

    test('resolve throws on missing service', () {
      expect(() => ioc.resolve<Foo>(), throwsException);
    });

    test('resolveOrNull returns null on missing service', () {
      expect(ioc.resolveOrNull<Foo>(), isNull);
    });
  });

  group('make type safety', () {
    final ioc = IocContainer();

    tearDown(ioc.dispose);

    test('make returns typed instance', () {
      final result = ioc.make<AbstractClass>(Foo.new);
      expect(result, isA<Foo>());
    });
  });

  group('validateBindings', () {
    final ioc = IocContainer();

    tearDown(ioc.dispose);

    test('passes when all required services are registered', () {
      ioc
        ..require<AbstractClass>()
        ..require<Foo>()
        ..bind<AbstractClass>(Foo.new)
        ..bind<Foo>(Foo.new);

      expect(ioc.validateBindings, returnsNormally);
    });

    test('throws with missing services listed', () {
      ioc
        ..require<AbstractClass>()
        ..require<Foo>()
        ..bind<Foo>(Foo.new);

      expect(
        ioc.validateBindings,
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('AbstractClass'),
        )),
      );
    });

    test('passes with no requirements', () {
      ioc.bind<Foo>(Foo.new);
      expect(ioc.validateBindings, returnsNormally);
    });
  });

  group('scoped containers', () {
    final parent = IocContainer();

    tearDown(parent.dispose);

    test('child resolves services from parent', () {
      parent.bind<AbstractClass>(Foo.new);
      final child = parent.createScope();

      expect(child.resolve<AbstractClass>(), isA<Foo>());
    });

    test('child can override parent service without polluting parent', () {
      parent.bind<AbstractClass>(Foo.new);
      final child = parent.createScope()..bind<AbstractClass>(Bar.new);

      expect(child.resolve<AbstractClass>(), isA<Bar>());
      expect(parent.resolve<AbstractClass>(), isA<Foo>());
    });

    test('child resolveOrNull falls back to parent', () {
      parent.bind<Foo>(Foo.new);
      final child = parent.createScope();

      expect(child.resolveOrNull<Foo>(), isA<Foo>());
    });

    test('child resolveOrNull returns null when neither has service', () {
      final child = parent.createScope();
      expect(child.resolveOrNull<Foo>(), isNull);
    });
  });

  group('scopedIoc', () {
    test('replaces and restores global container', () {
      final scope = IocContainer()..bind<Foo>(Foo.new);

      final restore = scopedIoc(scope);
      expect(ioc.resolve<Foo>(), isA<Foo>());

      restore();
      expect(ioc.resolveOrNull<Foo>(), isNull);

      scope.dispose();
    });
  });
}
