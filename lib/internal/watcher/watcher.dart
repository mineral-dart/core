import 'dart:io';

import 'package:mineral/internal/services/embedded/embedded_application.dart';
import 'package:mineral/internal/watcher/directory_watcher_element.dart';
import 'package:watcher/watcher.dart';

final class Watcher {
  final Directory appRoot;
  final EmbeddedApplication application;
  late final List<DirectoryWatcherElement> watchers = [];
  final bool allowReload;
  void Function(WatchEvent event) onReload;

  Watcher({ required this.allowReload, required this.appRoot, required this.application, required List<Directory> roots, required this.onReload }) {
    watchers.addAll(List.from(
      roots.map((root) =>
        DirectoryWatcherElement(
          appRoot: appRoot,
          watcherRoot: root,
          addFile: onReload,
          editFile: onReload,
          removeFile: onReload
        )
      )
    ));
  }

  void watch() {
    for (final watcher in watchers) {
      watcher.watch();
    }
  }
}