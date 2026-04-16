import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef VoiceDisconnectEventHandler = FutureOr Function(VoiceState);

abstract class VoiceDisconnectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.voiceDisconnect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState state);
}
