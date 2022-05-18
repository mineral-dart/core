part of api;

class TextChannel extends TextBasedChannel {
  TextChannel({
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
  );

  Future<TextChannel?> update ({ String? label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw }) async {
    Http http = ioc.singleton('Mineral/Core/Http');

    Response response = await http.patch("/channels/$id", {
      'name': label ?? this.label,
      'topic': description,
      'parent_id': categoryChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': [],
    });

    dynamic payload = jsonDecode(response.body);
    TextChannel channel = TextChannel.from(payload);

    // Define deep properties
    channel.guildId = guildId;
    channel.guild = guild;
    channel.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }

  factory TextChannel.from(dynamic payload) {
    return TextChannel(
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
