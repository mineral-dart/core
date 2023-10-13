import 'package:mineral/internal/app/contracts/embedded_application_contract.dart';
import 'package:mineral/internal/wss/entities/websocket_event_dispatcher.dart';
import 'package:mineral/internal/wss/entities/websocket_response.dart';
import 'package:mineral/services/logger/logger_contract.dart';

final class EmbeddedProduction implements EmbeddedApplication {
  final WebsocketEventDispatcher dispatcher = WebsocketEventDispatcher();
  final LoggerContract _logger;

  EmbeddedProduction(this._logger);

  @override
  void dispatch(WebsocketResponse response) {
    dispatcher.dispatch(response);
  }
}