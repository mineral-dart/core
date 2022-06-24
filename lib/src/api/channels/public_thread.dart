part of api;

class PublicThread extends Channel {

  String? name;
  Snowflake? lastMessageId;
  DateTime? lastPinTimstamp;

  PublicThread({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
  }) : super(
    id: id,
    type: ChannelType.guildPublicThread,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
  );

  Future<void> create (Snowflake message, String name) async {
    Http http = ioc.singleton(Service.http);
    await http.post('/channels/$id/messages/$message/threads', {
      'name': name,
    });
  }

  factory PublicThread.from(dynamic payload) {
    return PublicThread(
      id: payload['id'],
      guildId: payload['guild_id'],
      position: payload['position'],
      label: payload['name'],
      applicationId: payload['application_id'],
      parentId: payload['parent_id'],
      flags: payload['flags'],
    );
  }

}