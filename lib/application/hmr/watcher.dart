import 'dart:io';

import 'package:mineral/application/hmr/directory_watcher_element.dart';
import 'package:watcher/watcher.dart';

final class Watcher {
  final Directory appRoot;
  late final List<DirectoryWatcherElement> watchers = [];
  final bool allowReload;
  void Function(WatchEvent event) onReload;

  Watcher({ required this.allowReload, required this.appRoot, required List<Directory> roots, required this.onReload }) {
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
