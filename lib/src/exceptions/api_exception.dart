import 'package:mineral/src/internal/managers/reporter_manager.dart';
import 'package:mineral_ioc/ioc.dart';

class ApiException implements Exception {
  int code;
  String cause;

  ApiException({ required this.code, required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.use<ReporterManager>();
    if (reporter != null) {
      reporter.write('[ $code ] $cause');
    }

    return '[ $code ] $cause';
  }
}
