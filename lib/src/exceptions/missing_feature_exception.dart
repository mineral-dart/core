import 'package:mineral/core/extras.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/debugger.dart';

class MissingFeatureException with Container, Console implements Exception {
  final String message;

  MissingFeatureException(this.message) {
    container.use<Debugger>()
      .debug(message);
  }

  @override
  String toString () => message;
}

