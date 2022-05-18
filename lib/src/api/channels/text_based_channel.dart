part of api;

class TextBasedChannel extends Channel {
  String? description;
  bool nsfw;
  Snowflake? lastMessageId;
  DateTime? lastPinTimestamp;

  TextBasedChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required this.description,
    required this.nsfw,
    required this.lastMessageId,
    required this.lastPinTimestamp,
  }) : super(
    id: id,
    type: ChannelType.guildText,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
  );

  Future<bool> delete () async {
    Http http = ioc.singleton('Mineral/Core/Http');
    Response response = await http.destroy("/channels/$id");

    guild?.channels.cache.remove(id);

    return response.statusCode == 200;
  }
}
