final class MissingMethodException implements Exception {
  final String message;

  MissingMethodException(this.message);

  @override
  String toString() {
    return 'MissingMethodException: $message';
  }
}
