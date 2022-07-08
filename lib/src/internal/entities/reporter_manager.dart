import 'dart:io';

import 'package:path/path.dart';

class ReporterManager {
  final Directory _reportDirectory;
  late File currentFile;

  ReporterManager(this._reportDirectory);

  void write (String message) {
    final DateTime now = DateTime.now();
    final String filename = 'log-${now.day}-${now.month}-${now.year}.txt';

    final file = File(join(_reportDirectory.path, filename));
    final bool fileExist = file.existsSync();

    if (!fileExist) {
      file.createSync(recursive: true);
    }

    int timestamp = DateTime.now().millisecondsSinceEpoch;
    file.writeAsStringSync('[$timestamp] $message\n', mode: FileMode.writeOnlyAppend);
  }
}
