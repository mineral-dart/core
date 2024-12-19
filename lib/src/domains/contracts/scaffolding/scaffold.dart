import 'dart:io';

import 'package:mineral/container.dart';

abstract interface class ScaffoldContract {
  File get entrypoint;
  Directory get rootDir;
  Directory get libDir;
  Directory? get binDir;
  Directory? get configDir;
  IocContainer get container;
}
