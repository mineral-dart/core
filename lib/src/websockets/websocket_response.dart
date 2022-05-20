import 'dart:convert';

import 'package:http/http.dart';

class WebsocketResponse {
  String? type;
  int op;
  int? sequence;
  dynamic payload;

  WebsocketResponse({ this.type, required this.op, this.sequence, required this.payload });

  factory WebsocketResponse.from(String socket) {
    dynamic json = jsonDecode(socket);

    return WebsocketResponse(
      type: json['t'],
      op: json['op'],
      sequence: json['s'],
      payload: json['d'],
    );
  }
}

class AuthenticationResponse {
  String url;
  AuthenticationResponse({ required this.url });

  factory AuthenticationResponse.fromResponse (Response response) {
    dynamic json = jsonDecode(response.body);
    return AuthenticationResponse(url: json['url']);
  }
}
