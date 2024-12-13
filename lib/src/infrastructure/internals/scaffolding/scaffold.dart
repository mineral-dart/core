import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:path/path.dart';

final class DefaultScaffold implements ScaffoldContract {
  @override
  File get entrypoint => switch(binDir) {
    Directory(:final path) => File(join(path, 'main.dart')),
    _ => throw PathException('Missing "bin" folder in your project.')
  };

  @override
  Directory get rootDir => Directory.current;

  @override
  Directory? get binDir => Directory(join(rootDir.path, 'bin'));

  @override
  Directory get libDir => Directory(join(rootDir.path, 'lib'));

  @override
  Directory? get configDir => Directory(join(rootDir.path, 'config'));
}
