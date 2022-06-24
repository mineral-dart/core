part of api;


class NewsChannel extends TextBasedChannel {

  NewsChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required Snowflake? description,
    required bool nsfw,
    required Snowflake? lastMessageId,
    required DateTime? lastPinTimestamp,
  }) : super(
    id: id,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
    description: description,
    nsfw: nsfw,
    lastMessageId: lastMessageId,
    lastPinTimestamp: lastPinTimestamp,
    messages: MessageManager(id, guildId),
    threads: ThreadManager(guildId: guildId)
  );

  @override
  Future<NewsChannel> setDescription (String description) async {
    return await super.setDescription(description);
  }
  
  Future<void> follow (Snowflake channel) async {
    Http http = ioc.singleton(Service.http);
    await http.post('/channels/$id/followers', {
      'webhook_channel_id': channel,
    });
  }

  factory NewsChannel.from(dynamic payload) {
    return NewsChannel(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      parentId: payload['parent_id'],
      flags: payload['flags'],
      description: payload['topic'],
      nsfw: payload['nsfw'] ?? false,
      lastMessageId: payload['last_message_id'],
      lastPinTimestamp: payload['last_pin_timestamp'] != null ? DateTime.parse(payload['last_pin_timestamp']) : null,
    );
  }
}