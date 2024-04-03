import 'package:mineral/application/environment/environment.dart';
import 'package:mineral/domains/data/event_bucket.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';

abstract interface class MineralClientContract {
  EnvContract get environment;
  EventBucket get events;

  void register(ListenableEvent Function() event);
  Future<void> init();
}
