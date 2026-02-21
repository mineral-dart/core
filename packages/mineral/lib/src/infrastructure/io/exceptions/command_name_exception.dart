final class CommandNameException implements Exception {
  final String message;

  CommandNameException(this.message);

  @override
  String toString() {
    return 'CommandNameException: $message';
  }
}
