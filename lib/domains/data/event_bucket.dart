import 'package:mineral/domains/data/event_buckets/private_bucket.dart';
import 'package:mineral/domains/data/event_buckets/server_bucket.dart';
import 'package:mineral/domains/data/events/common/ready_event.dart';
import 'package:mineral/infrastructure/commons/mineral_event.dart';
import 'package:mineral/infrastructure/commons/types/kernel_contract.dart';

final class EventBucket {
  final KernelContract _kernel;

  late final ServerBucket server;
  late final PrivateBucket private;

  EventBucket(this._kernel) {
    server = ServerBucket(this);
    private = PrivateBucket(this);
  }

  void make<T extends Function>(EventList event, T handle) => _registerEvent<T>(event: event, handle: handle);

  void ready(ReadyEventHandler handle) => _registerEvent(event: MineralEvent.ready, handle: handle);

  void _registerEvent<T extends Function>({required EventList event, required T handle}) =>
      _kernel.dataListener.events.listen(
        event: event,
        handle: handle,
      );
}
