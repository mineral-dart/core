import 'package:mineral/api.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commands/command_declaration_bucket.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/commons/utils/listenable.dart';
import 'package:mineral/src/domains/events/event_bucket.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/domains/commons/kernel.dart';

import '../events/types/listenable_event.dart';

final class Client {
  final KernelContract _kernel;

  final EventBucket events;

  final CommandBucket commands;

  IocContainer get container => ioc;

  EnvContract get environment => _kernel.environment;

  LoggerContract get logger => _kernel.logger;

  CommandInteractionManagerContract get _commands =>
      ioc.resolve<CommandInteractionManagerContract>();

  Client(KernelContract kernel)
      : events = EventBucket(kernel),
        commands = CommandBucket(),
        _kernel = kernel;

  void register<T>(Listenable Function() constructor) {
    final instance = constructor();

    return switch (instance) {
      final CommandContract command => _commands.addCommand(command.build()),
      final GlobalState state => _kernel.globalState.register<T>(state as T),
      final Provider provider => _kernel.providerManager.register(provider),
      final ListenableEvent event => _kernel.eventListener.listen(
          event: event.event,
          handle: (instance as dynamic).handle as Function,
          customId: event.customId),
      _ => throw UnimplementedError(),
    };
  }

  Future<void> init() => _kernel.init();
}
