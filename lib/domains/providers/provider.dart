import 'dart:async';

abstract class ProviderContract {
  FutureOr<void> ready() {}
  FutureOr<void> dispose() {}
}
