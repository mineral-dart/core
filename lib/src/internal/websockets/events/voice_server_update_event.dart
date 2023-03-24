import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class VoiceServerUpdate extends Event {
  final Guild _guild;
  final String _voiceToken;
  final String _endpoint;

  VoiceServerUpdate(this._guild, this._voiceToken, this._endpoint);

  Guild get guild => _guild;
  String get voiceToken => _voiceToken;
  String get endpoint => _endpoint;
}
