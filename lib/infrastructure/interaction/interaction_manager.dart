import 'package:mineral/infrastructure/interaction/commands/command.dart';
import 'package:mineral/infrastructure/interaction/interaction_dispatcher.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

abstract class InteractionManagerContract {
  final Map<String, Command> commands = {};
  late InteractionDispatcherContract dispatcher;

  void addCommand(Command command);
  Future<void> init();
}

final class InteractionManager implements InteractionManagerContract {
  @override
  final Map<String, Command> commands = {};

  @override
  late InteractionDispatcherContract dispatcher;

  InteractionManager() {
    dispatcher = InteractionDispatcher(this);
  }

  @override
  void addCommand(Command command) {
    commands[command.name!] = command;
  }

  @override
  Future<void> init() async {
    ioc.bind('interactionManager', () => this);
    final command = commands.entries.first.value;
    final kernel = Kernel.singleton();

    final response = await kernel.httpClient.post("/applications/INSERT ID HERE/commands", body: command.builder.toJson()); // todo
    print(response.body);
  }

  factory InteractionManager.singleton() {
    return ioc.resolve('interactionManager');
  }
}