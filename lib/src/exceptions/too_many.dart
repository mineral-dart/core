import 'package:mineral/console.dart';

class TooMany implements Exception {
  String prefix;
  String cause;
  TooMany({ required this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
