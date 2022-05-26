import 'dart:convert';
import 'dart:io';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:http/http.dart';
import 'package:mineral/src/internal/websockets/websocket_dispatcher.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';


class WebsocketManager {
  WebsocketDispatcher websocketDispatcher = WebsocketDispatcher();
  late final WebSocket websocket;
  final Http http;
  late String token;

  WebsocketManager(this.http);

  Future<Response> getWebsocketEndpoint (int version) async {
    return http.get("/v$version/gateway/bot");
  }

  Future<WebSocket> connect ({ required String token }) async {
    this.token = token;
    http.defineHeader(header: 'Authorization', value: "Bot $token");

    Response response = await getWebsocketEndpoint(Constants.apiVersion);
    AuthenticationResponse authenticationResponse = AuthenticationResponse.fromResponse(response);

    websocket = await WebSocket.connect(authenticationResponse.url);
    Console.info(message: 'Websocket is connected');

    _send(OpCode.identify, {
      'token': token,
      'intents': 131071,
      'properties': { '\$os': 'linux' }
    });

    websocket.listen(_listen, onDone: _done);
    return websocket;
  }

  Future<void> _listen (event) async {
    WebsocketResponse websocket = WebsocketResponse.from(event);
    if (websocket.op == OpCode.dispatch) {
      await websocketDispatcher.dispatch(websocket);
    }
  }

  void _done () {
    Console.info(message: 'Websocket channel was closed');
  }

  void _send (int code, Object payload) {
    websocket.add(jsonEncode({
      'op': code,
      'd': payload
    }));
  }
}
