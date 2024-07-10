import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:test/expect.dart';
import 'package:test/test.dart';

abstract interface class AbstractClass {}

final class Foo implements AbstractClass {}
final class FooWithoutAbstract {}

void main() {
  group('service ioc', () {
    final ioc = IocContainer();

    test('can bind service with concrete type', () {
      ioc.bind(Foo, Foo.new);
      expect(ioc.resolve<Foo>(), isA<Foo>());
    });

    test('can bind service with abstract type', () {
      ioc.bind(AbstractClass, Foo.new);
      expect(ioc.resolve<AbstractClass>(), isA<Foo>());
    });

    test("can't resolve service by abstract class when haven't", () {
      ioc.bind(AbstractClass, FooWithoutAbstract.new);
      expect(() => ioc.resolve<FooWithoutAbstract>(), throwsException);
    });
  });
}
