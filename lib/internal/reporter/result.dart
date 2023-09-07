final class Success<V, E> implements Result<V, E> {
  final V value;
  const Success(this.value);
}

final class Failure<V, E> implements Result<V, E> {
  final E error;
  final StackTrace? stackTrace;
  const Failure(this.error, { this.stackTrace });
}

sealed class Result<V, E> {
  factory Result.success(V value) = Success<V, E>;
  factory Result.failure(E error, { StackTrace? stackTrace }) = Failure<V, E>;
}