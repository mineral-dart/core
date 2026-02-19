import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef VoiceJoinEventHandler = FutureOr Function(VoiceState);

abstract class VoiceJoinEvent implements ListenableEvent {
  @override
  Event get event => Event.voiceJoin;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState state);
}
