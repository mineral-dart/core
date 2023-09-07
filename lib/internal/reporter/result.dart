final class Success<V, E> implements Result<V, E> {
  final V value;
  const Success(this.value);
}

final class Error<V, E> implements Result<V, E> {
  final E value;
  const Error(this.value);
}

sealed class Result<V, E> {
  factory Result.success(V value) = Success<V, E>;
  factory Result.error(E value) = Error<V, E>;
}