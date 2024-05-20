import 'package:mineral/domains/events/event_bucket.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/listenable.dart';
import 'package:mineral/infrastructure/internals/environment/environment.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

abstract interface class MineralClientContract {
  EnvContract get environment;

  EventBucket get events;

  void register(Listenable Function() event);

  Future<void> init();
}

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
  void register(Listenable Function() event) {
    final instance = event();

    switch (instance) {
      case ListenableEvent():
        _kernel.eventListener.listen(
          event: instance.event,
          handle: (instance as dynamic).handle as Function,
        );
    }
  }

  @override
  Future<void> init() => _kernel.init();
}
