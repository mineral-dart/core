import 'dart:io';

import 'package:mineral/src/infrastructure/internals/hmr/entities/directory_watcher_element.dart';
import 'package:mineral/src/infrastructure/internals/hmr/entities/file_watcher_element.dart';
import 'package:mineral/src/infrastructure/internals/hmr/entities/watcher_element.dart';
import 'package:watcher/watcher.dart';

final class Watcher {
  final Directory appRoot;
  late final List<WatcherElement> watchers = [];
  final bool allowReload;
  void Function(WatchEvent event) onReload;

  Watcher(
      {required this.allowReload,
      required this.appRoot,
      required List<Directory> folders,
      required List<File> files,
      required this.onReload}) {
    watchers.addAll(List.from([
      ...folders.map((folder) => DirectoryWatcherElement(
          appRoot: appRoot,
          watcherRoot: folder,
          addFile: onReload,
          editFile: onReload,
          removeFile: onReload)),
      ...files.map((file) => FileWatcherElement(
          appRoot: appRoot,
          watchedFile: file,
          addFile: onReload,
          editFile: onReload,
          removeFile: onReload))
    ]));
  }

  void watch() {
    for (final watcher in watchers) {
      watcher.watch();
    }
  }
}
