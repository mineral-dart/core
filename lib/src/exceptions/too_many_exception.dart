import 'package:mineral/core/extras.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';

class TooManyException with Container, Console implements Exception {
  final String message;

  TooManyException(this.message) {
    container.use<DebuggerService>()
        .debug(message);
  }

  @override
  String toString () => message;
}

