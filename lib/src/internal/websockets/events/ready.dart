import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class Ready extends Event {
  final MineralClient _client;

  Ready(this._client);

  MineralClient get client => _client;
}