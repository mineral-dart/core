import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class TooManyElementException extends RecoverableMineralException {
  TooManyElementException(super.message);
}
