import 'package:mineral/domains/data/event_buckets/private_bucket.dart';
import 'package:mineral/domains/data/event_buckets/server_bucket.dart';
import 'package:mineral/domains/data/events/ready_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

final class EventBucket {
  final MineralClientContract _client;

  late final ServerBucket server;
  late final PrivateBucket private;

  EventBucket(this._client) {
    server = ServerBucket(this);
    private = PrivateBucket(this);
  }

  void make<T extends Function>(EventList event, T handle) => _registerEvent<T>(event: event, handle: handle);

  void ready(ReadyEventHandler handle) => _registerEvent(event: MineralEvent.ready, handle: handle);

  void _registerEvent<T extends Function>({required EventList event, required T handle}) =>
      _client.kernel.dataListener.events.listen(
        event: event,
        handle: handle,
      );
}
