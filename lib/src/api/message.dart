part of api;



class Message {
  Snowflake id;
  String content;
  bool tts;
  // List<> embeds;
  bool allowMentions;
  Message? reference;
  // List<> components;
  // List<> stickers;
  // List<> files;
  // Map<String, dynamic> payload;
  // List<> attachments;
  int? flags;
  Snowflake channelId;
  TextBasedChannel channel;

  Message({
    required this.id,
    required this.content,
    required this.tts,
    // required this.embeds,
    required this.allowMentions,
    required this.reference,
    // required this.components,
    // required this.stickers,
    // required this.files,
    // required this.payload,
    // required this.attachments,
    required this.flags,
    required this.channelId,
    required this.channel,
  });

  Future<Message> sync () async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.get("/channels/${channel.id}");
    dynamic payload = jsonDecode(response.body);

    Message message = Message.from(channel: channel, payload: payload);
    channel.messages.cache.set(message.id, message);

    return message;
  }

  Future<void> createThread ({ required String name, ArchiveDuration? duration, int? rateLimit }) async {
    if (rateLimit == null || rateLimit > 21600) {
      Console.error(message: 'The value of rateLimit is greater than 21600');
      return;
    }
    Http http = ioc.singleton(Service.http);
    await http.post("/channels/$channelId/messages/$id/threads", {
      "name": name,
      "auto_archive_duration": duration,
      "rate_limit_per_user": rateLimit
    });
  }

  factory Message.from({ required TextBasedChannel channel, required dynamic payload }) {
    return Message(
      id: payload['id'],
      content: payload['content'],
      tts: payload['tts'],
      allowMentions: payload['allow_mentions'] ?? false,
      reference: payload['reference'],
      flags: payload['flags'],
      channelId: channel.id,
      channel: channel,
    );
  }
}
