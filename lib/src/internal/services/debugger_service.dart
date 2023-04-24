import 'dart:io';

import 'package:mineral/core/extras.dart';
import 'package:mineral/src/internal/services/environment_service.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';
import 'package:tint/tint.dart';

class DebuggerService extends MineralService with Container {
  final String prefix;

  DebuggerService(this.prefix): super(inject: true);

  void debug (String message) {
    final service =  container.use<EnvironmentService>();

    if (service.get('LOG_LEVEL') == 'debug') {
      stdout.writeln(prefix.grey() + ' $message');
    }

    if (service.get('DEBUGGER') == 'true') {
      _write(message);
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