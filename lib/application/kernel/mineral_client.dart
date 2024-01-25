import 'package:mineral/domains/data/event_bucket.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

final class MineralClient implements MineralClientContract {
  late final EventBucket events;

  @override
  final KernelContract kernel;

  MineralClient(this.kernel) {
    events = EventBucket(this);
  }

  @override
  void register(ListenableEvent Function() event) {
    final instance = event();

    switch (instance) {
      case ListenableEvent():
        kernel.dataListener.events
            .listen(event: instance.event, handle: (instance as dynamic).handle);
    }
  }

  @override
  Future<void> init() async {
    await kernel.init();
  }
}
