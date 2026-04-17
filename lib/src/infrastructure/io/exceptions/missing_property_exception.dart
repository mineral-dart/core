import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class MissingPropertyException extends RecoverableMineralException {
  MissingPropertyException(super.message);
}
