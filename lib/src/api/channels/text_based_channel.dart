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

  Future<dynamic> setDescription (String description) async {
    Http http = ioc.singleton('Mineral/Core/Http');
    Response response = await http.patch("/channels/$id", { 'topic': description });

    if (response.statusCode == 200) {
      this.description = description;
    }

    return this;
  }

  Future<dynamic> setNsfw (bool value) async {
    Http http = ioc.singleton('Mineral/Core/Http');
    Response response = await http.patch("/channels/$id", { 'nsfw': value });

    if (response.statusCode == 200) {
      nsfw = value;
    }

    return this;
  }

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

  Future<bool> delete () async {
    Http http = ioc.singleton('Mineral/Core/Http');
    Response response = await http.destroy("/channels/$id");

    guild?.channels.cache.remove(id);

    return response.statusCode == 200;
  }
}
