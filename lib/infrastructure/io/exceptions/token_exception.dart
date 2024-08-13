final class TokenException implements Exception {
  final String message;
  final dynamic body;

  TokenException(this.message, {this.body});

  @override
  String toString() {
    return 'TokenException: $message\n$body';
  }
}
