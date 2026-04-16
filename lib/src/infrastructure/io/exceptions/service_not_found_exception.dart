import 'package:mineral/src/infrastructure/io/exceptions/mineral_exception.dart';

final class ServiceNotFoundException extends MineralException {
  final Type serviceType;

  ServiceNotFoundException(this.serviceType)
      : super('Service "$serviceType" not found in the container');
}
