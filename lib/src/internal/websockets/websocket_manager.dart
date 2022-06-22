import 'dart:convert';
import 'dart:io';

import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:http/http.dart';
import 'package:mineral/src/api/client/mineral_client.dart';
import 'package:mineral/src/internal/websockets/websocket_dispatcher.dart';
import 'package:mineral/src/internal/websockets/websocket_response.dart';


class WebsocketManager {
  WebsocketDispatcher websocketDispatcher = WebsocketDispatcher();
  late final WebSocket websocket;
  final Http http;
  late String token;
  late List<Intent> intents;

  WebsocketManager(this.http);

  Future<Response> getWebsocketEndpoint (int version) async {
    return http.get(url: "/v$version/gateway/bot");
  }

  Future<WebSocket> connect ({ required String token, required List<Intent> intents }) async {
    this.token = token;
    http.defineHeader(header: 'Authorization', value: "Bot $token");

    this.intents = intents.contains(Intent.all)
      ? Intent.values.map((intent) => intent).toList()
      : intents;

    Response response = await getWebsocketEndpoint(Constants.apiVersion);
    AuthenticationResponse authenticationResponse = AuthenticationResponse.fromResponse(response);

    websocket = await WebSocket.connect(authenticationResponse.url);
    Console.info(message: 'Websocket is connected');

    send(OpCode.identify, {
      'token': token,
      'intents': Intent.getIntent(intents),
      'properties': { '\$os': 'linux' }
    });

    websocket.listen(_listen, onDone: _done);
    return websocket;
  }

  Future<void> _listen (event) async {
    WebsocketResponse websocket = WebsocketResponse.from(event);
    if (websocket.op == OpCode.dispatch.value) {
      await websocketDispatcher.dispatch(websocket);
    }
  }

  void _done () {
    Console.info(message: 'Websocket channel was closed');
  }

  void send (OpCode code, Object payload) {
    websocket.add(jsonEncode({
      'op': code.value,
      'd': payload
    }));
  }
}
