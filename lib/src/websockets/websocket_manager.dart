import 'dart:convert';
import 'dart:io';

import 'package:mineral/core.dart';
import 'package:http/http.dart';
import 'package:mineral/src/websockets/websocket_dispatcher.dart';
import 'package:mineral/src/websockets/websocket_response.dart';


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

    send(OpCode.identify, {
      'token': token,
      'intents': 131071,
      'properties': { '\$os': 'linux' }
    });

    websocket.listen((event) async {
      WebsocketResponse websocket = WebsocketResponse.from(event);
      if (websocket.op == OpCode.dispatch) {
        await websocketDispatcher.dispatch(websocket);
      }
    });

    return websocket;
  }

  void send (int code, Object payload) {
    websocket.add(jsonEncode({
      'op': code,
      'd': payload
    }));
  }
}
