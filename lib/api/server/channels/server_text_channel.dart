import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/marshaller/memory_storage.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerTextChannel extends ServerChannel {
  final String? description;

  final ServerCategoryChannel? category;

  ServerTextChannel({
    required String id,
    required String name,
    required int position,
    required this.description,
    required this.category,
  }): super(id, name, position);

  factory ServerTextChannel.fromJson(MemoryStorageContract storage, String guildId, Map<String, dynamic> json) {
    return ServerTextChannel(
      id: json['id'],
      name: json['name'],
      position: json['position'],
      description: json['topic'],
      category: createOrNull(field: json['parent_id'], fn: () => storage.channels[json['parent_id']] as ServerCategoryChannel?)
    );
  }
}
