part of exception;

class EmptyParameterException implements Exception {
  String prefix = 'INVALID PARAMETER';
  String cause;
  EmptyParameterException({ required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
