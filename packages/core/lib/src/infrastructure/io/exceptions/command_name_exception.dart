import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class CommandNameException extends RecoverableMineralException {
  CommandNameException(super.message);
}
