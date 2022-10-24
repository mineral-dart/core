import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/reporter_manager.dart';

class HttpException  implements Exception {
  int code;
  String cause;

  HttpException({ required this.code, required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.singleton(Service.reporter);
    if (reporter != null) {
      reporter.write('[ $code ] $cause');
    }

    return '[ $code ] $cause';
  }
}