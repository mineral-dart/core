import 'dart:async';

abstract interface class ProviderContract {
  FutureOr<void> ready();
  FutureOr<void> dispose();
}

abstract class Provider implements ProviderContract {
  @override
  FutureOr<void> ready() {}

  @override
  FutureOr<void> dispose() {}
}
