import 'package:mineral/api/common/commands/builder/command_builder.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/events/event_bucket.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/listenable.dart';
import 'package:mineral/infrastructure/internals/environment/environment.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

abstract interface class MineralClientContract {
  EnvContract get environment;
  EventBucket get events;
  Snowflake get id;

  void register(Listenable Function() event);
  void registerCommand(CommandBuilder builder);

  Future<void> init();
}

final class MineralClient implements MineralClientContract {
  final KernelContract _kernel;

  @override
  late final EventBucket events;

  @override
  late final Snowflake id;

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
  void registerCommand(CommandBuilder builder) {
    final command = builder.toCommand();
    _kernel.interactionManager.addCommand(command);
    print('Command registered: ${command.name}');
  }

  @override
  Future<void> init() => _kernel.init();

  static MineralClientContract singleton() => MineralClient(Kernel.singleton());
}
