import 'package:mineral/console.dart';

class MissingMethodException implements Exception {
  String prefix = 'MISSING METHOD';
  String cause;

  MissingMethodException({ required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
