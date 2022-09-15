import 'package:mineral/console.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class CodeErrorException implements Exception {
  String? prefix;
  String cause;
  CodeErrorException({ this.prefix, required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.singleton(Service.reporter);
    if (reporter != null) {
      reporter.write('[ $prefix ] $cause');
    }

    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
