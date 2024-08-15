final class TooManyElementException implements Exception {
  final String message;

  TooManyElementException(this.message);

  @override
  String toString() {
    return 'TooManyElementException: $message';
  }
}
