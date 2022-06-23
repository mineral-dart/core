import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/helper.dart';

enum WebhookType {
  incoming(1),
  channelFollower(2),
  application(3);

  final int value;
  const WebhookType(this.value);
}

class Webhook {
  Snowflake id;
  WebhookType type;
  Snowflake? guildId;
  late Guild? guild;
  Snowflake? channelId;
  late Channel? channel;
  User? user;
  String? label;
  String? avatar;
  String token;
  Snowflake? applicationId;
  dynamic sourceGuild;
  dynamic sourceChannel;
  String? url;

  Webhook({
    required this.id,
    required this.type,
    required this.guildId,
    required this.channelId,
    required this.label,
    required this.avatar,
    required this.token,
    required this.applicationId,
    required this.sourceGuild,
    required this.sourceChannel,
    required this.url,
  });

  Future<void> setName (String label) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/webhooks/$id", payload: { 'name': label });

    if (response.statusCode == 200) {
      this.label = label;
    }
  }

  Future<void> setAvatar (String avatar) async {
    Http http = ioc.singleton(ioc.services.http);
    String path = await Helper.getPicture(avatar);
    Response response = await http.patch(url: "/webhooks/$id", payload: { 'avatar': path });

    if (response.statusCode == 200) {
      avatar = path;
    }
  }

  Future<void> update ({ String? label, String? avatar }) async {
    Http http = ioc.singleton(ioc.services.http);
    String? path = avatar != null
      ?  await Helper.getPicture(avatar)
      : this.label;

    Response response = await http.patch(url: "/webhooks/$id", payload: {
      'label': label ?? this.label,
      'avatar': path,
    });

    if (response.statusCode == 200) {
      if (label != null) this.label = label;
      if (avatar != null) this.avatar = path;
    }
  }

  Future<void> execute ({ String? content, String? username, String? avatarUrl, bool? tts, List<MessageEmbed>? embeds, List<Row>? components, bool? suppressEmbed }) async {
    Http http = ioc.singleton(ioc.services.http);

    List<dynamic> embedList = [];
    if (embeds != null) {
      for (MessageEmbed element in embeds) {
        embedList.add(element.toJson());
      }
    }

    List<dynamic> componentList = [];
    if (components != null) {
      for (Row element in components) {
        componentList.add(element.toJson());
      }
    }

    await http.post(url: "/webhooks/$id/$token", payload: {
      'username': username,
      'avatar_url': avatarUrl,
      'content': content,
      'embeds': embeds != null ? embedList : [],
      'components': components != null ? componentList : [],
      'tts': tts ?? false,
      'flags': MessageFlag.suppressEmbeds.value
    });
  }

  Future<bool> delete () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/webhooks/$id/$token");

    return response.statusCode == 200;
  }

  factory Webhook.from ({ required dynamic payload }) {
    return Webhook(
      id: payload['id'],
      type: WebhookType.values.firstWhere((element) => element.value == payload['type']),
      guildId: payload['guild_id'],
      channelId: payload['channel_id'],
      label: payload['name'],
      avatar: payload['avatar'],
      token: payload['token'],
      applicationId: payload['application_id'],
      sourceGuild: payload['source_guild'],
      sourceChannel: payload['source_channel'],
      url: payload['url']
    );
  }
}
