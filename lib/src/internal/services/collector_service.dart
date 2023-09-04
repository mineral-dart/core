import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral_ioc/ioc.dart';

class CollectorService extends MineralService {
  final List<Collector> _collectors = [];
  final Map<String, Collector> _namedCollectors = {};

  CollectorService(): super(inject: true);

  void subscribe (Collector collector, { String? uid }) {
    if (uid != null) {
      _namedCollectors.putIfAbsent(uid, () => collector);
      return;
    }

    _collectors.add(collector);
  }

  void unsubscribe (Collector collector, { String? uid }) {
    if (uid != null) {
      _namedCollectors.remove(uid);
      return;
    }

    _collectors.remove(collector);
  }

  void emit (Type event, dynamic payload) {
    final collectors = _collectors.where((collector) => collector.event == event);
    for (final collector in collectors) {
      collector.controller.add(payload);
    }

    for (final collector in _namedCollectors.values) {
      collector.controller.add(payload);
    }
  }
}
