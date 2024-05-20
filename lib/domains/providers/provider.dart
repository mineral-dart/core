import 'dart:async';

abstract interface class ProviderContract {
  FutureOr<void> ready();
  FutureOr<void> dispose();
}
