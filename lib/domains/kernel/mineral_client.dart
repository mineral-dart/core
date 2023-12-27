import 'package:mineral/domains/events/functional_event_registrar.dart';
import 'package:mineral/domains/kernel/types/kernel_contract.dart';
import 'package:mineral/domains/kernel/types/mineral_client_contract.dart';

final class MineralClient implements MineralClientContract {
  @override
  late final FunctionalEventRegistrarContract fn;

  @override
  final KernelContract kernel;

  MineralClient(this.kernel) {
    fn = FunctionalEventRegistrar(this);
  }

  @override
  Future<void> init() async {
    await kernel.init();
  }
}
