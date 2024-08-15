final class TokenException implements Exception {
  final String message;

  TokenException(this.message);

  @override
  String toString() {
    return 'TokenException: $message';
  }
}
