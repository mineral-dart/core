import 'package:mineral/src/domains/commons/kernel.dart';
import 'package:mineral/src/domains/events/buckets/private_bucket.dart';
import 'package:mineral/src/domains/events/buckets/server_bucket.dart';
import 'package:mineral/src/domains/events/contracts/common/ready_event.dart';
import 'package:mineral/src/domains/events/contracts/common/voice_state_update_event.dart';
import 'package:mineral/src/domains/events/event.dart';

final class EventBucket {
  final Kernel _kernel;

  late final ServerBucket server;
  late final PrivateBucket private;

  EventBucket(this._kernel) {
    server = ServerBucket(this);
    private = PrivateBucket(this);
  }

  void make<T extends Function>(Event event, T handle, {String? customId}) =>
      _registerEvent<T>(event: event, handle: handle, customId: customId);

  void ready(ReadyEventHandler handle) =>
      _registerEvent(event: Event.ready, handle: handle);

  void voiceStateUpdate(VoiceStateUpdateEventHandler handle) =>
      _registerEvent(event: Event.voiceStateUpdate, handle: handle);

  void voiceJoin(VoiceStateUpdateEventHandler handle) =>
      _registerEvent(event: Event.voiceJoin, handle: handle);

  void voiceLeave(VoiceStateUpdateEventHandler handle) =>
      _registerEvent(event: Event.voiceLeave, handle: handle);

  void voiceMove(VoiceStateUpdateEventHandler handle) =>
      _registerEvent(event: Event.voiceMove, handle: handle);

  void _registerEvent<T extends Function>(
          {required Event event, required T handle, String? customId}) =>
      _kernel.eventListener
          .listen(event: event, handle: handle, customId: customId);
}
