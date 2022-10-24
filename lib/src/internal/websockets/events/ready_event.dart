import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ReadyEvent extends Event {
  final MineralClient _client;

  ReadyEvent(this._client);

  MineralClient get client => _client;
}