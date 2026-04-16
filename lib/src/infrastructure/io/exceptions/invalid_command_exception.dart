import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class InvalidCommandException extends MineralException {
  InvalidCommandException(super.message);
}
