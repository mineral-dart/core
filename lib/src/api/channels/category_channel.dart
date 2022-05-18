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

  Future<T?> update<T> ({ String? label, int? position }) async {
    Http http = ioc.singleton('Mineral/Core/Http');

    Response response = await http.patch("/channels/$id", {
      'name': label,
      'position': position,
      'permission_overwrites': [],
    });

    dynamic payload = jsonDecode(response.body);
    CategoryChannel channel = CategoryChannel.from(payload);

    // Define deep properties
    channel.guildId = guildId;
    channel.guild = guild;
    channel.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel as T;
  }

  Future<bool> delete () async {
    Http http = ioc.singleton('Mineral/Core/Http');
    Response response = await http.destroy("/channels/$id");

    guild?.channels.cache.remove(id);

    return response.statusCode == 200;
  }

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
