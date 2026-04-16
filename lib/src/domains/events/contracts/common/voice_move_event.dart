import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef VoiceMoveEventHandler = FutureOr Function(VoiceState);

abstract class VoiceMoveEvent extends BaseListenableEvent {
  @override
  Event get event => Event.voiceMove;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState? before, VoiceState after);
}
