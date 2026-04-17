import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class MissingMethodException extends RecoverableMineralException {
  MissingMethodException(super.message);
}
