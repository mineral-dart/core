import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/exception.dart';

class ShardMessage {
  ShardCommand command;
  dynamic data;

  ShardMessage({required this.command, required this.data});

  factory ShardMessage.from(dynamic rawData) {
    return ShardMessage(command: rawData["command"], data: rawData["data"]);
  }
}

enum ShardCommand {
  init, data, error, disconnected, send;
}