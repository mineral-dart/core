import 'package:mineral/core/extras.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/debugger_service.dart';

class MissingFeatureException with Container, Console implements Exception {
  final String message;

  MissingFeatureException(this.message) {
    container.use<DebuggerService>()
      .debug(message);
  }

  @override
  String toString () => message;
}

