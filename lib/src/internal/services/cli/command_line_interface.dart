import 'package:args/args.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/commands/compile/exe.dart';
import 'package:mineral/src/commands/compile/js.dart';
import 'package:mineral/src/commands/help.dart';
import 'package:mineral/src/commands/make/command.dart';
import 'package:mineral/src/commands/make/event.dart';
import 'package:mineral/src/commands/make/package.dart';
import 'package:mineral/src/commands/make/service.dart';
import 'package:mineral/src/commands/make/shared_state.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral/src/internal/services/console/themes/console_theme.dart';
import 'package:mineral/src/internal/services/console/themes/default_theme.dart';
import 'package:mineral/src/internal/services/environment_service.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';

/// The command line interface service is used to inject the CLI commands of your applications and packages used by the cli.
/// ```dart
/// final cli = CommandLineInterface(packages: [
///   SomePackage()
/// ]);
///
/// await cli.handle(arguments);
/// ```
///
/// NOTE : All commands are automatically registered into the help command.
///
/// NOTE : Used packages should extend the [MineralPackageContract](https://pub.dev/packages/mineral_contract) contracts.
class CommandLineInterface extends CliServiceContract {
  /// List of packages used by the cli
  final List<MineralPackageContract> packages;

  /// The [ArgParser] used to parse the arguments
  final ArgParser _parser = ArgParser();

  /// The [Map] of [CliCommandContract] used by this
  final Map<String, CliCommandContract> _commands = {};

  /// The [ConsoleService] used to display messages in this
  final ConsoleService _console = ConsoleService(theme: DefaultTheme());

  CommandLineInterface({ this.packages = const [] }) {
    ioc.bind((ioc) => ConsoleService(theme: ConsoleTheme()));
    ioc.bind((ioc) => EnvironmentService());

    register([
      MakeEvent(_console),
      MakeCommand(_console),
      MakeSharedState(_console),
      MakePackage(_console),
      MakeService(_console),
      CompileExecutable(_console),
      CompileJavascript(_console),
      Help(_console, _commands),
    ]);

    for (final package in packages) {
      ioc.bind((ioc) => package);
      register(package.injectCommands());
    }
  }

  /// The [ConsoleService] used to display messages in the console
  @override
  ConsoleService get console => _console;

  /// Register your commands into the command line interface service.
  ///
  /// Automatically register into the help command.
  @override
  void register (List<CliCommandContract> commands) {
    for (final command in commands) {
      _commands.putIfAbsent(command.name, () => command);

      final ArgParser parser = ArgParser();
      if (command.arguments.isNotEmpty) {
        for (final argument in command.arguments) {
          parser.addOption(argument);
        }
      }

      _parser.addCommand(command.name, parser);
    }
  }

  /// Handle the command line arguments to execute the given entry command.
  @override
  Future<void> handle (List<String> arguments) async {
    await ioc.use<EnvironmentService>().load();

    ArgResults results = _parser.parse(arguments);
    final command = _commands.getOrFail(results.command?.name ?? 'help');

    if (command.arguments.isNotEmpty && results.arguments.length - 1 != command.arguments.length) {
      final params = command.arguments
        .map((e) => '<$e>')
        .join(', ');

      command.console.error('Please provide $params params.');
      return;
    }

    final params = {};
    for (int i = 0; i < command.arguments.length; i++) {
      params.putIfAbsent(command.arguments[i], () => results.arguments[i + 1]);
    }

    return await command.handle(params);
  }
}