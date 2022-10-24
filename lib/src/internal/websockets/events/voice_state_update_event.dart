import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class VoiceStateUpdateEvent extends Event {
  final VoiceManager _before;
  final VoiceManager _after;

  VoiceStateUpdateEvent(this._before, this._after);

  VoiceManager get before => _before;
  VoiceManager get after => _after;
}