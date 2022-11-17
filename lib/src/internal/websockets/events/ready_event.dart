import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ReadyEvent extends Event {
  final MineralClient _client;

  ReadyEvent(this._client);

  MineralClient get client => _client;
}