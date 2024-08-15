final class MissingPropertyException implements Exception {
  final String message;

  MissingPropertyException(this.message);

  @override
  String toString() {
    return 'MissingPropertyException: $message';
  }
}
