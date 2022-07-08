import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/reporter_manager.dart';

class EmptyParameterException implements Exception {
  String prefix = 'INVALID PARAMETER';
  String cause;
  EmptyParameterException({ required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.singleton(ioc.services.reporter);
    if (reporter != null) {
      reporter.write('[ $prefix ] $cause');
    }

    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
