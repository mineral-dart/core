import 'package:mineral/core/extras.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';

class InvalidParameterException with Container, Console implements Exception {
  final String message;

  InvalidParameterException(this.message) {
    container.use<DebuggerService>()
        .debug(message);
  }

  @override
  String toString () => message;
}
