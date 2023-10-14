import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';

final class EmbeddedProduction implements EmbeddedApplication {
  @override
  Future<void> spawn() {
    throw UnimplementedError();
  }

}