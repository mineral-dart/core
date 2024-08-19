import 'dart:io';

import 'package:mineral/infrastructure/internals/hmr/entities/watcher_element.dart';
import 'package:watcher/watcher.dart';

final class FileWatcherElement implements WatcherElement {
  final Directory appRoot;
  final File watchedFile;
  late final FileWatcher _watcher;

  final void Function(WatchEvent event) addFile;
  final void Function(WatchEvent event) editFile;
  final void Function(WatchEvent event) removeFile;

  FileWatcherElement({
    required this.appRoot,
    required this.watchedFile,
    required this.addFile,
    required this.editFile,
    required this.removeFile
  }) {
    _watcher = FileWatcher(watchedFile.path);
  }

  @override
  void watch() {
    _watcher.events.listen(dispatch);
  }

  @override
  void dispatch (WatchEvent event) {
    return switch (event.type) {
      ChangeType.ADD => addFile(event),
      ChangeType.MODIFY => editFile(event),
      ChangeType.REMOVE => removeFile(event),
      _ => null
    };
  }
}
