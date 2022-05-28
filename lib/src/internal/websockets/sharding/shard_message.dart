class ShardMessage {
  ShardCommand command;
  dynamic data;

  ShardMessage({required this.command, this.data});

  factory ShardMessage.from(dynamic rawData) {
    return ShardMessage(command: rawData["command"], data: rawData["data"]);
  }
}

enum ShardCommand {
  init, data, error, disconnected, reconnect, send, terminate, terminate_ok;
}