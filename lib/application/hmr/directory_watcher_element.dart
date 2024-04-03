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

  void watch() {
    _watcher.events.listen(dispatch);
  }

  void dispatch (WatchEvent event) {
    return switch (event.type) {
      ChangeType.ADD => addFile(event),
      ChangeType.MODIFY => editFile(event),
      ChangeType.REMOVE => removeFile(event),
      _ => null
    };
  }
}
