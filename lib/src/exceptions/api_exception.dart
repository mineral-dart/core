import 'package:mineral/core/extras.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';

class ApiException with Container, Console implements Exception {
  final String message;

  ApiException(this.message) {
    container.use<DebuggerService>()
      .debug(message);
  }

  @override
  String toString () => message;
}
