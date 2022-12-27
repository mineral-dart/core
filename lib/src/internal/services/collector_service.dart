import 'package:mineral/src/api/collectors/collector.dart';
import 'package:mineral_ioc/ioc.dart';

class CollectorService extends MineralService {
  final List<Collector> _collectors = [];

  CollectorService(): super(inject: true);

  void subscribe (Collector collector) {
    _collectors.add(collector);
  }

  void unsubscribe (Collector collector) {
    _collectors.remove(collector);
  }

  void emit (Type event, dynamic payload) {
    final collectors = _collectors.where((collector) => collector.event == event);
    for (final collector in collectors) {
      collector.controller.add(payload);
    }
  }
}
