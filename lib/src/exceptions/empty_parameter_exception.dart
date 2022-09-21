import 'package:mineral/console.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class EmptyParameterException implements Exception {
  String prefix = 'INVALID PARAMETER';
  String cause;
  EmptyParameterException({ required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.singleton(Service.reporter);
    if (reporter != null) {
      reporter.write('[ $prefix ] $cause');
    }

    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
