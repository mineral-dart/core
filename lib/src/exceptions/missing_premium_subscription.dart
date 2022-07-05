import 'package:mineral/console.dart';

class MissingPremiumSubscription implements Exception {
  String? prefix;
  String cause;
  MissingPremiumSubscription({ this.prefix, required this.cause });

  @override
  String toString () {
    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
