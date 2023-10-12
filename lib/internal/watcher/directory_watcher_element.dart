import 'dart:io';
import 'package:watcher/watcher.dart';

final class DirectoryWatcherElement {
  final Directory appRoot;
  final Directory watcherRoot;
  late final DirectoryWatcher _watcher;

  final void Function(WatchEvent event) addFile;
  final void Function(WatchEvent event) editFile;
  final void Function(WatchEvent event) removeFile;

  DirectoryWatcherElement({
    required this.appRoot,
    required this.watcherRoot,
    required this.addFile,
    required this.editFile,
    required this.removeFile
  }) {
    _watcher = DirectoryWatcher(watcherRoot.path);
  }

  watch() {
    _watcher.events.listen(dispatch);
  }

  void dispatch (WatchEvent event) {

    switch (event.type) {
      case ChangeType.ADD:
        addFile(event);
      case ChangeType.MODIFY:
        editFile(event);
      case ChangeType.REMOVE:
        removeFile(event);
    }
  }
}