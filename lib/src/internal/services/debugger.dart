import 'dart:io';

import 'package:mineral/core/extras.dart';
import 'package:mineral/src/internal/managers/environment_manager.dart';
import 'package:mineral_console/mineral_console.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

class Debugger extends MineralService with Container {
  final String prefix;

  Debugger(this.prefix): super(inject: true);

  void debug (String message) {
    final service =  container.use<EnvironmentManager>();

    if (service.environment.getFromStringKey('LOG_LEVEL') == 'debug') {
      stdout.writeln(prefix.grey() + ' $message');
    }

    if (service.environment.getFromStringKey('DEBUGGER') == 'true') {
      _write('$prefix $message');
    }
  }

  void _write (String message) {
    final DateTime now = DateTime.now();
    final String filename = 'log-${now.day}-${now.month}-${now.year}.txt';

    final debuggerDirectory = Directory(join(Directory.current.path, 'logs'));
    if (!debuggerDirectory.existsSync()) {
      debuggerDirectory.createSync(recursive: true);
    }

    final file = File(join(debuggerDirectory.path, filename));
    final bool fileExist = file.existsSync();

    if (!fileExist) {
      file.createSync(recursive: true);
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    file.writeAsStringSync('[$timestamp] $message\n', mode: FileMode.writeOnlyAppend);
  }
}