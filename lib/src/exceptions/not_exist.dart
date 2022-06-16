import 'package:mineral/console.dart';

class NotExist implements Exception {
  String? prefix;
  String cause;
  NotExist({ this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
