import 'package:mineral/core/extras.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/services/debugger.dart';

class HttpException with Container, Console implements Exception {
  final String message;

  HttpException(this.message) {
    container.use<Debugger>()
      .debug(message);
  }

  @override
  String toString () => message;
}