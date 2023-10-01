import 'dart:io';
import 'package:watcher/watcher.dart';

final class DirectoryWatcherElement {
  final Directory appRoot;
  final Directory watcherRoot;
  late final DirectoryWatcher _watcher;

  final void Function() addFile;
  final void Function() editFile;
  final void Function() removeFile;

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

  String makeRelativePath (String path) =>
    path.replaceFirst(appRoot.path, '').substring(1);

  void dispatch (WatchEvent event) {
    final String location = makeRelativePath(event.path);

    switch (event.type) {
      case ChangeType.ADD:
        print('add: $location');
        addFile();

      case ChangeType.MODIFY:
        print('modify: $location');
        editFile();

      case ChangeType.REMOVE:
        print('delete: $location');
        removeFile();
    }
  }
}