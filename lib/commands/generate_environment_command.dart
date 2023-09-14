import 'package:mineral/internal/console/command.dart';
import 'package:mineral/services/env/environment.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class GenerateEnvironmentCommand extends Command {
  final LoggerContract _logger;

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
        _logger.success('Environment file created successfully!');
      })
      .catchError((err) {
        _logger.error(err.toString());
      });
  }
}