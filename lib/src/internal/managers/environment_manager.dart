import 'dart:convert';
import 'dart:io';

import 'package:interact/interact.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_environment/environment.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

class EnvironmentManager extends MineralService {
  final MineralEnvironment environment = MineralEnvironment();

  EnvironmentManager(): super(inject: true);

  Future<MineralEnvironment> load () async {
    File file = File(join(Directory.current.path, '.env'));
    if (!await file.exists()) {
      await createEnvironmentFile();
      exit(0);
    }

    List<String> content = await file.readAsLines(encoding: utf8);

    for (String line in content) {
      if (line.isNotEmpty) {
        List<String> content = line.split(':');
        String key = content.removeAt(0).trim();
        String value = content.join(':').trim();

        environment.data.putIfAbsent(key, () => value);
      }
    }

    return environment;
  }

  Future<void> createEnvironmentFile () async {
    String token = '';
    Console.info(message: 'We will create your environment file..');

    final withToken = Confirm(
      prompt: 'Would you like to define your token now?',
      defaultValue: true,
    ).interact();

    if (!withToken) {
      Console.warn(message: 'Don\'t forget to set your token before restarting your application');
    } else {
      token = Input(prompt: 'What is your token ?').interact();
    }

    final environmentFile = File(join(Directory.current.path, '.env'));
    final sink = environmentFile.openWrite();
    sink.write(['APP_NAME: My mineral application', 'APP_TOKEN: $token', 'LOG_LEVEL: info', 'REPORTER: debug'].join('\n'));

    await sink.flush();
    await sink.close();
  }
}