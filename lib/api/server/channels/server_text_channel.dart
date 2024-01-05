import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerTextChannel extends ServerChannel {
  final String? description;

  ServerTextChannel({
    required String id,
    required String name,
    required int position,
    required this.description,
  }): super(id, name, position);

  factory ServerTextChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerTextChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['topic'],
    );
  }
}
