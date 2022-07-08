import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/entities/reporter_manager.dart';

class ShardException implements Exception {
  String? prefix;
  String cause;
  ShardException({ this.prefix, required this.cause });

  @override
  String toString () {
    ReporterManager? reporter = ioc.singleton(ioc.services.reporter);
    if (reporter != null) {
      reporter.write('[ $prefix ] $cause');
    }

    return Console.getErrorMessage(prefix: prefix, message: cause);
  }
}
