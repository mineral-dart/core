import 'package:mineral/application/environment/environment.dart';
import 'package:mineral/domains/data/event_bucket.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

final class MineralClient implements MineralClientContract {
  final KernelContract _kernel;

  @override
  late final EventBucket events;

  @override
  EnvContract get environment => _kernel.environment;

  MineralClient(KernelContract kernel)
      : events = EventBucket(kernel),
        _kernel = kernel;

  @override
  void register(ListenableEvent Function() event) {
    final instance = event();

    switch (instance) {
      case ListenableEvent():
        _kernel.dataListener.events
            .listen(event: instance.event, handle: (instance as dynamic).handle);
    }
  }

  @override
  Future<void> init() => _kernel.init();
}
