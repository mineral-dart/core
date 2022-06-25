import 'package:mineral/console.dart';

class AlreadyExist implements Exception {
  String prefix = 'AlreadyExist';
  String cause;
  AlreadyExist({ required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
