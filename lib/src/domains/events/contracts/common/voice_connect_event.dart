import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef VoiceConnectEventHandler = FutureOr Function(VoiceState);

abstract class VoiceConnectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.voiceConnect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(VoiceState state);
}
