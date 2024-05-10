import 'package:mineral/domains/events/buckets/private_bucket.dart';
import 'package:mineral/domains/events/buckets/server_bucket.dart';
import 'package:mineral/domains/events/contracts/common/ready_event.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

final class EventBucket {
  final KernelContract _kernel;

  late final ServerBucket server;
  late final PrivateBucket private;

  EventBucket(this._kernel) {
    server = ServerBucket(this);
    private = PrivateBucket(this);
  }

  void make<T extends Function>(Event event, T handle) => _registerEvent<T>(event: event, handle: handle);

  void ready(ReadyEventHandler handle) => _registerEvent(event: Event.ready, handle: handle);

  void _registerEvent<T extends Function>({required Event event, required T handle}) =>
    _kernel.eventListener.listen(
      event: event,
      handle: handle,
    );
}
