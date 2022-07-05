import 'package:mineral/console.dart';

class MissingFeatureException implements Exception {
  String prefix = 'MISSING FEATURE';
  String cause;

  MissingFeatureException({ required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
