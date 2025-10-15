import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef VoiceLeaveEventHandler = FutureOr Function(VoiceState?, VoiceState);

abstract class VoiceLeaveEvent implements ListenableEvent {
  @override
  Event get event => Event.voiceLeave;

  @override
  String? customId;

  FutureOr<void> handle(VoiceState before, VoiceState after);
}
