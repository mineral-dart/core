import 'package:mineral/console.dart';

class AlreadyExist implements Exception {
  String? prefix;
  String cause;
  AlreadyExist({ this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
