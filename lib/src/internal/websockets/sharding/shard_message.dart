/// ShardMessage represent the messages that can be exchanged between the Shard
/// and the isolate.
///
/// {@category Internal}
class ShardMessage {
  ShardCommand command;
  dynamic data;

  ShardMessage({required this.command, this.data});

  factory ShardMessage.from(dynamic rawData) {
    return ShardMessage(command: rawData["command"], data: rawData["data"]);
  }
}

enum ShardCommand {
  init, data, error, disconnected, reconnect, send, terminate, terminateOk;
}