import 'package:mineral/console.dart';

class TokenException implements Exception {
  String? prefix;
  String cause;
  TokenException({ this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
