import 'dart:async';

extension type AsyncList<T>(Iterable<FutureOr<T>> fn) {
  static AsyncList? nullable<T>(Iterable<FutureOr<T>>? fn) {
    return switch (fn) {
      Iterable<FutureOr<T>>() => AsyncList<T>(fn),
      _ => null,
    };
  }
}
