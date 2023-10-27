import 'package:logging/logging.dart';
import 'package:mineral/internal/services/console/command.dart';
import 'package:mineral/services/env/environment.dart';

final class GenerateEnvironmentCommand extends Command {
  final Logger _logger;

  GenerateEnvironmentCommand(this._logger): super(
    name: 'gen:env',
    description: 'Generates a .env file with the required environment variables',
  );

  @override
  Future<void> handle () async {
    final Environment env = Environment.singleton();

    env.createEnvironmentFile();
    env.write({ 'APP_TOKEN': 'your_app_token' })
      .then((value) {
        _logger.info('Environment file created successfully!');
      })
      .catchError((err) {
        _logger.severe(err);
      });
  }
}