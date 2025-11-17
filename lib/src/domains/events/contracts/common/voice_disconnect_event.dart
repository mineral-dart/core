import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef VoiceDisconnectEventHandler = FutureOr Function(VoiceState);

abstract class VoiceDisconnectEvent implements ListenableEvent {
  @override
  Event get event => Event.voiceDisconnect;

  @override
  String? customId;

  FutureOr<void> handle(VoiceState state);
}
