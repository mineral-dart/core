import 'package:mineral/api/common/commands/command_contract.dart';
import 'package:mineral/domains/commands/command_declaration_bucket.dart';
import 'package:mineral/domains/events/event_bucket.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/listenable.dart';
import 'package:mineral/infrastructure/internals/environment/environment.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

abstract interface class MineralClientContract {
  LoggerContract get logger;

  EnvContract get environment;

  EventBucket get events;

  CommandBucket get commands;

  void register(Listenable Function() event);

  void registerCommand(CommandContract Function() command);

  Future<void> init();
}

final class MineralClient implements MineralClientContract {
  final KernelContract _kernel;

  @override
  late final EventBucket events;

  @override
  late final CommandBucket commands;

  @override
  EnvContract get environment => _kernel.environment;

  @override
  LoggerContract get logger => _kernel.logger;

  MineralClient(KernelContract kernel)
      : events = EventBucket(kernel),
        commands = CommandBucket(kernel),
        _kernel = kernel;

  @override
  void register(Listenable Function() event) {
    final instance = event();

    switch (instance) {
      case ListenableEvent():
        _kernel.eventListener.listen(
            event: instance.event,
            handle: (instance as dynamic).handle as Function,
            customId: instance.customId
        );
    }
  }

  @override
  void registerCommand(CommandContract Function() command) {
    final instance = command();
    _kernel.commands.addCommand(instance.build());
  }

  @override
  Future<void> init() => _kernel.init();
}
