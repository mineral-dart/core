import 'dart:async';

abstract class EitherContract {}

class Either<V, E> implements EitherContract {
  Either._();

  static Success<T> success<T>(T value) => Success<T>(value);
  static Failure<E> failure<E>(dynamic error, { E? payload, StackTrace? stackTrace }) => Failure<E>(error, payload: payload, stackTrace: stackTrace);

  static Future future<V, E> ({ required Future future, EitherContract? Function(Failure<E>)? onError }) async {
    try {
      final result = await future;

      if (result is Success) {
        return result;
      }

      if (result is Failure) {
        return onError != null
          ? onError(result as Failure<E>)
          : result;
      }

      return Either.success(result);
    } catch (error, stackTrace) {
      final result = Either.failure<E>(error, stackTrace: stackTrace);

      return onError != null
        ? onError(result)
        : result;
    }
  }

  static tryCatch<V>(V Function() run, Function(Failure) onError) {
    try {
      return Either.success<V>(run());
    } catch (e, s) {
      return onError(Failure(e, stackTrace: s));
    }
  }
}

final class Success<V> implements EitherContract {
  final V value;
  Success(this.value);

  bool get hasValue => value != null;
}

final class Failure<T> implements EitherContract {
  final dynamic error;
  final T? payload;
  final StackTrace? stackTrace;

  Failure(this.error, { this.payload, this.stackTrace });

  Failure throwWithStackTrace({ String? message }) {
    throw Error.throwWithStackTrace(Exception(message ?? error), stackTrace ?? StackTrace.current);
  }

  Failure reThrow() {
    if (stackTrace != null) {
      throw error.withStackTrace(stackTrace);
    }

    throw Exception(error);
  }
}