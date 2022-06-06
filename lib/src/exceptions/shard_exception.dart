part of exception;

class ShardException implements Exception {
  String? prefix;
  String cause;
  ShardException({ this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
