import 'package:mineral/console.dart';

class NotExist implements Exception {
  String prefix = 'NotExist';
  String cause;
  NotExist({ required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
