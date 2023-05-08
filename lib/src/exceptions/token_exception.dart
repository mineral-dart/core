import 'package:mineral/core/extras.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';

class TokenException with Container, Console implements Exception {
  final String message;

  TokenException(this.message) {
    container.use<DebuggerService>()
      .debug(message);
  }

  @override
  String toString () => message;
}
