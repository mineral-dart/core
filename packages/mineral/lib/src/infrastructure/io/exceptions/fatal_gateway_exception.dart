final class FatalGatewayException implements Exception {
  final String message;
  final int code;

  FatalGatewayException(this.message, this.code);

  @override
  String toString() => 'FatalGatewayException($code): $message';
}
