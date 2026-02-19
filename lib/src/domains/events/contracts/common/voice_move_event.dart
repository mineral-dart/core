import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef VoiceMoveEventHandler = FutureOr Function(VoiceState);

abstract class VoiceMoveEvent implements ListenableEvent {
  @override
  Event get event => Event.voiceMove;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState? before, VoiceState after);
}
