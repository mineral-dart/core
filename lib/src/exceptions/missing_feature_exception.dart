import 'package:mineral/src/console.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class MissingFeatureException implements Exception {
  String prefix = 'MISSING FEATURE';
  String cause;

  MissingFeatureException({ required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.use<ReporterManager>();
    if (reporter != null) {
      reporter.write('[ $prefix ] $cause');
    }

    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
