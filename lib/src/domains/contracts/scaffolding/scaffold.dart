import 'dart:io';

abstract interface class ScaffoldContract {
  File get entrypoint;
  Directory get rootDir;
  Directory get libDir;
  Directory? get binDir;
  Directory? get configDir;
}
