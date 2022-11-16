import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class InvalidParameterException implements Exception {
  String cause;
  InvalidParameterException({ required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.use<ReporterManager>();
    if (reporter != null) {
      reporter.write('[ Invalid parameter ] $cause');
    }

    return '[ Invalid parameter ] $cause';
  }
}
