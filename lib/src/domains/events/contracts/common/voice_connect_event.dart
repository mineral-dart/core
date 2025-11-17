import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef VoiceConnectEventHandler = FutureOr Function(VoiceState);

abstract class VoiceConnectEvent implements ListenableEvent {
  @override
  Event get event => Event.voiceConnect;

  @override
  String? customId;

  FutureOr<void> handle(VoiceState state);
}
