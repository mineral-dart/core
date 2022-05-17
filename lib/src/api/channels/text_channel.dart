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
