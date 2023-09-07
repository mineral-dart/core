import 'dart:async';

class Either<V, E> {
  Either._();

  factory Either.success(V value) = Success<V, E>;
  factory Either.failure(E error, { StackTrace? stackTrace }) = Failure<V, E>;

  static Future<Either<V, E>> future<V, E> ({ required Future future, Function(Failure<V, E>)? onError }) async {
    try {
      final result = await future;
      return Success(result);
    } catch (e, s) {
      final failure = Failure<V, E>(e, stackTrace: s);

      if (onError != null) {
        return onError(failure);
      }

      return failure;
    }
  }

  factory Either.tryCatch(V Function() run, Function(Failure) onError) {
    try {
      return Success(run());
    } catch (e, s) {
      return onError(Failure(e, stackTrace: s));
    }
  }
}

final class Success<V, E> extends Either<V, E> {
  final V value;
  Success(this.value): super._();

  bool get hasValue => value != null;
}

final class Failure<V, E> extends Either<V, E> {
  final dynamic error;
  final StackTrace? stackTrace;

  Failure(this.error, { this.stackTrace }): super._();

  void throwWithStackTrace({ String? message }) {
    throw Error.throwWithStackTrace(Exception(message ?? error), stackTrace!);
  }

  void reThrow() {
    if (stackTrace != null) {
      throw error.withStackTrace(stackTrace);
    }

    throw error;
  }
}