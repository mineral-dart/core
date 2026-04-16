import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef VoiceStateUpdateEventHandler = FutureOr Function(VoiceState);

abstract class VoiceStateUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.voiceStateUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState state);
}
