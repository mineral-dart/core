import 'package:mineral/api/server/channels/server_channel.dart';

final class ServerCategoryChannel extends ServerChannel {
  ServerCategoryChannel({
    required String id,
    required String name,
    required int position,
  }): super(id, name, position);

  factory ServerCategoryChannel.fromJson(String guildId, Map<String, dynamic> json) {
    return ServerCategoryChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
    );
  }
}
