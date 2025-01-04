import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef VoiceStateUpdateEventHandler = FutureOr Function(VoiceState);

abstract class VoiceStateUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.voiceStateUpdate;

  @override
  String? customId;

  FutureOr<void> handle(VoiceState state);
}
