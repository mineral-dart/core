import 'package:mineral/domains/providers/provider.dart';

abstract interface class ProviderManagerContract {
  void register(ProviderContract provider);
  Future<void> ready();
  Future<void> dispose();
}

final class ProviderManager implements ProviderManagerContract {
  final List<ProviderContract> _providers = [];

  @override
  void register(ProviderContract provider) {
    _providers.add(provider);
  }

  @override
  Future<void> ready() async {
    for (final provider in _providers) {
      await provider.ready();
    }
  }


  @override
  Future<void> dispose() async {
    for (final provider in _providers) {
      await provider.dispose();
    }
  }
}
