import 'dart:io';

import 'package:mineral/internal/watcher/directory_watcher_element.dart';
import 'package:mineral/internal/wss/websocket_manager.dart';

final class Hmr {
  final Directory appRoot;
  final WebsocketManager wss;
  late final List<DirectoryWatcherElement> watchers = [];
  final bool allowReload;

  Hmr({ required this.allowReload, required this.appRoot, required this.wss, required List<Directory> roots }) {
    watchers.addAll(List.from(
      roots.map((root) =>
        DirectoryWatcherElement(
          appRoot: appRoot,
          watcherRoot: root,
          addFile: restart,
          editFile: restart,
          removeFile: restart
        )
      )
    ));
  }

  void restart () {
    if (allowReload) {
      print('restard');
    }
  }

  watch() {
    for (final watcher in watchers) {
      watcher.watch();
    }
  }
}
