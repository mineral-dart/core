import 'package:mineral/core/extras.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';

class UnsupportedException with Container, Console implements Exception {
  final String message;

  UnsupportedException(this.message) {
    container.use<DebuggerService>()
      .debug(message);
  }

  @override
  String toString () => message;
}
