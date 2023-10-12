import 'dart:io';

import 'package:mineral/internal/services/embedded/embedded_application.dart';
import 'package:mineral/internal/watcher/watcher.dart';
import 'package:watcher/watcher.dart' as watcher;

final class WatcherBuilder {
  final Directory _appRoot;
  EmbeddedApplication? _application;
  final List<Directory> _watchers = [];
  bool _allowReload = false;
  void Function(watcher.WatchEvent) _onReload = (_) {};

  WatcherBuilder(this._appRoot);

  WatcherBuilder setAllowReload (bool value) {
    _allowReload = value;
    return this;
  }

  WatcherBuilder setApplication (EmbeddedApplication value) {
    _application = value;
    return this;
  }

  WatcherBuilder addWatchFolder (Directory value) {
    _watchers.add(value);
    return this;
  }

  WatcherBuilder onReload (Function(watcher.WatchEvent) callback) {
    _onReload = callback;
    return this;
  }

  Watcher build () => Watcher(
    allowReload: _allowReload,
    appRoot: _appRoot,
    application: _application!,
    roots: _watchers,
    onReload: _onReload
  );
}