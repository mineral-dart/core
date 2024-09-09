import 'dart:io';

import 'package:mineral/src/infrastructure/internals/hmr/watcher.dart';
import 'package:watcher/watcher.dart' as watcher;

final class WatcherBuilder {
  final Directory _appRoot;
  final List<Directory> _folderWatchers = [];
  final List<File> _fileWatchers = [];

  bool _allowReload = false;
  void Function(watcher.WatchEvent) _onReload = (_) {};

  WatcherBuilder(this._appRoot);

  WatcherBuilder setAllowReload(bool value) {
    _allowReload = value;
    return this;
  }

  WatcherBuilder addWatchFolder(Directory value) {
    _folderWatchers.add(value);
    return this;
  }

  WatcherBuilder addWatchFile(File value) {
    _fileWatchers.add(value);
    return this;
  }

  WatcherBuilder onReload(Function(watcher.WatchEvent) callback) {
    _onReload = callback;
    return this;
  }

  Watcher build() => Watcher(
      allowReload: _allowReload,
      appRoot: _appRoot,
      folders: _folderWatchers,
      files: _fileWatchers,
      onReload: _onReload);
}
