import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/commands/command_declaration_bucket.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/commons/utils/listenable.dart';
import 'package:mineral/src/domains/events/event_bucket.dart';
import 'package:mineral/src/domains/services/kernel.dart';

import '../events/types/listenable_event.dart';

final class Client {
  final KernelContract _kernel;

  final EventBucket events;

  final CommandBucket commands;

  IocContainer get container => ioc;

  EnvContract get environment => _kernel.environment;

  LoggerContract get logger => _kernel.logger;

  DataStoreContract get rest => ioc.resolve<DataStoreContract>();

  WebsocketOrchestratorContract get wss => _kernel.wss;

  CommandInteractionManagerContract get _commands =>
      ioc.resolve<CommandInteractionManagerContract>();

  InteractiveComponentService get components => _kernel.interactiveComponent;

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
      final InteractiveComponent component =>
        _kernel.interactiveComponent.register(component),
      _ => throw UnimplementedError(),
    };
  }

  Future<void> init() => _kernel.init();
}
