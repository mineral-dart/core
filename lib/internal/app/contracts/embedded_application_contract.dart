import 'package:mineral/internal/wss/entities/websocket_response.dart';

abstract interface class EmbeddedApplication {
  Future<void> spawn();
}