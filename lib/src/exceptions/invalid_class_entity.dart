import 'package:mineral/console.dart';

class InvalidClassEntity implements Exception {
  String prefix = 'InvalidClassEntity';
  String cause;
  InvalidClassEntity({ required this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
