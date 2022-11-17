import 'package:mineral/src/console.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class ShardException implements Exception {
  String? prefix;
  String cause;
  ShardException({ this.prefix, required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.use<ReporterManager>();
    if (reporter != null) {
      reporter.write('[ $prefix ] $cause');
    }

    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
