part of api;

class CategoryChannel extends Channel {
  CategoryChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required int? flags,
  }) : super(
    id: id,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: null,
    type: ChannelType.guildCategory,
    flags: flags
  );

  factory CategoryChannel.from(dynamic payload) {
    return CategoryChannel(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      flags: payload['flags'],
    );
  }
}
