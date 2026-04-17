import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class InvalidComponentException extends RecoverableMineralException {
  InvalidComponentException(super.message);
}
