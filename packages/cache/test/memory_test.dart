import 'package:mineral/api.dart';
import 'package:mineral_cache/providers/memory.dart';
import 'package:test/test.dart';

void main() {
  test('can create in-memory provider', () {
    final provider = MemoryProvider(env);
    expect(provider.name, 'In memory provider');
  });

  test('can get elements', () {
    final provider = MemoryProvider(env);
    expect(provider.inspect(), hasLength(0));
  });

  test('can put elements', () {
    final provider = MemoryProvider(env);
    provider.put('key', 'value');
    expect(provider.has('key'), true);
  });

  test('can remove elements', () {
    final provider = MemoryProvider(env);
    provider.put('key', 'value');
    provider.remove('key');
    expect(provider.has('key'), false);
  });

  test('can remove many elements', () {
    final provider = MemoryProvider(env);
    provider.put('key1', 'value');
    provider.put('key2', 'value2');

    provider.removeMany(['key1', 'key2']);

    expect(provider.has('key1'), false);
    expect(provider.has('key2'), false);
  });
}
