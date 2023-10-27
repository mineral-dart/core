import 'package:logging/logging.dart';
import 'package:mineral/internal/factories/packages/package_factory.dart';
import 'package:mineral/internal/services/console/command.dart';
import 'package:mineral/internal/services/console/command_option.dart';

final class ConfigureCommand extends Command {
  final Logger _logger;

  ConfigureCommand(this._logger): super(
    name: 'configure',
    description: 'Configure installed package',
    options: [
      CommandOption(name: 'name', description: 'package name to configure')
    ]
  );

  @override
  Future<void> handle () async {
    final name = options.get('name');

    if (name == null) {
      _logger.severe('No package name was provided');
      return;
    }

    final packageFactory = PackageFactory.singleton();
    final package = packageFactory.packages
      .where((element) => element.packageName == name)
      .firstOrNull;

    if (package == null) {
      _logger.severe('Package $name is not installed');
      return;
    }

    await package.configure();
  }
}