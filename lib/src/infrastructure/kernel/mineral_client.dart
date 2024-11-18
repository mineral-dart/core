import 'package:mineral/src/domains/commands/command_declaration_bucket.dart';
import 'package:mineral/src/domains/events/event_bucket.dart';
import 'package:mineral/src/infrastructure/commons/listenable.dart';
import 'package:mineral/src/infrastructure/internals/environment/environment.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

import '../../../api.dart';
import '../../domains/events/types/listenable_event.dart';

abstract interface class MineralClientContract {
  LoggerContract get logger;

  EnvContract get environment;

  EventBucket get events;

  CommandBucket get commands;

  void register<T>(Listenable Function() event);

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
  void register<T>(Listenable Function() constructor) {
    final instance = constructor();

    return switch (instance) {
      final CommandContract command =>
        _kernel.commands.addCommand(command.build()),
      final GlobalState state => _kernel.globalState.register<T>(state as T),
      final Provider provider => _kernel.providerManager.register(provider),
      final ListenableEvent event => _kernel.eventListener.listen(
          event: event.event,
          handle: (instance as dynamic).handle as Function,
          customId: event.customId),
      _ => throw UnimplementedError(),
    };
  }

  @override
  Future<void> init() => _kernel.init();
}
