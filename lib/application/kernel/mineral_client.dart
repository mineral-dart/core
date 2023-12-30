import 'package:mineral/domains/data/functional_event_registrar.dart';
import 'package:mineral/domains/data/internal_event.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

final class MineralClient implements MineralClientContract {
  @override
  late final FunctionalEventRegistrarContract fn;

  @override
  final KernelContract kernel;

  MineralClient(this.kernel) {
    fn = FunctionalEventRegistrar(this);
  }

  @override
  void register(ListenableEvent Function() event) {
    final instance = event();

    switch (instance) {
      case ListenableEvent():
        kernel.dataListener.events.listen(InternalEvent(
            instance.event, (instance as dynamic).handle));
    }
  }

  @override
  Future<void> init() async {
    await kernel.init();
  }
}
