import 'dart:async';

import 'package:mineral/src/api/server/voice_state.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef VoiceJoinEventHandler = FutureOr Function(VoiceState);

abstract class VoiceJoinEvent extends BaseListenableEvent {
  @override
  Event get event => Event.voiceJoin;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState state);
}
