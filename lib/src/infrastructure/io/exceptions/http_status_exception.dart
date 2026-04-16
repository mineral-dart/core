import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class HttpStatusException extends MineralException {
  final int statusCode;
  final String body;

  HttpStatusException(this.statusCode, this.body)
      : super('Unexpected HTTP status $statusCode: $body');
}
