import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class InvalidCommandException extends RecoverableMineralException {
  InvalidCommandException(super.message);
}
