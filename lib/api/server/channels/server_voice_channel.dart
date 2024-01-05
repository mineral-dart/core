import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerVoiceChannel extends ServerChannel {
  ServerVoiceChannel({
    required String id,
    required String name,
    required int position,
  }): super(id, name, position);

  factory ServerVoiceChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerVoiceChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
