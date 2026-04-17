import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class SerializationException extends RecoverableMineralException {
  SerializationException(super.message);
}
