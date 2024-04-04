import 'package:watcher/watcher.dart';

abstract interface class WatcherElement {
  void watch();
  void dispatch (WatchEvent event);
}
