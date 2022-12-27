import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/source_channel.dart';
import 'package:mineral/src/api/guilds/guild.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_ioc/ioc.dart';

enum WebhookType {
  incoming(1),
  channelFollower(2),
  application(3);

  final int value;
  const WebhookType(this.value);
}

class Webhook {
  Snowflake _id;
  int _type;
  Snowflake? _guildId;
  Snowflake? _channelId;
  Snowflake? _creatorId;
  String? _label;
  String? _avatar;
  String _token;
  Snowflake? _applicationId;
  String? _url;
  SourceChannel? _sourceChannel;
  SourceGuild? _sourceGuild;

  Webhook(
    this._id,
    this._type,
    this._guildId,
    this._channelId,
    this._creatorId,
    this._label,
    this._avatar,
    this._token,
    this._applicationId,
    this._url,
    this._sourceChannel,
    this._sourceGuild,
  );

  Snowflake get id => _id;
  WebhookType get type => WebhookType.values.firstWhere((element) => element.value == _type);
  Guild? get guild => ioc.use<MineralClient>().guilds.cache.get(_guildId);
  GuildChannel? get channel => guild?.channels.cache.get(_channelId);
  User? get creator => guild?.members.cache.get(_creatorId);
  String? get label => _label;
  String? get avatar => _avatar;
  String get token => _token;
  Snowflake? get applicationId => _applicationId;
  String? get url => _url;
  SourceChannel? get sourceChannel => _sourceChannel;
  SourceGuild? get sourceGuild => _sourceGuild;

  /// ### Update the label of this
  ///
  /// Example :
  /// ```dart
  /// await webhook.setLabel('My webhook name');
  /// ```
  Future<void> setLabel (String label) async {
    Response response = await ioc.use<HttpService>().patch(url: "/webhooks/$id", payload: { 'name': label });

    if (response.statusCode == 200) {
      _label = label;
    }
  }

  /// ### Update the avatar of this
  ///
  /// Example :
  /// ```dart
  /// await webhook.setAvatar('assets/images/my_picture.png');
  /// ```
  Future<void> setAvatar (String avatar) async {
    String path = await Helper.getPicture(avatar);
    Response response = await ioc.use<HttpService>().patch(url: "/webhooks/$id", payload: { 'avatar': path });

    if (response.statusCode == 200) {
      avatar = path;
    }
  }

  /// ### Update the avatar of this
  ///
  /// Example :
  /// ```dart
  /// await webhook.setChannel('xxxxxxx');
  /// ```
  Future<void> setChannel (Snowflake channelId) async {
    Response response = await ioc.use<HttpService>().patch(url: "/webhooks/$id", payload: { 'channel_id': channelId });

    if (response.statusCode == 200) {
      _channelId = channelId;
    }
  }

  /// ### Updates multiple properties of this in a single request.
  /// When you need to update more than 2 fields, we advise you to use this method to reduce the number of outgoing requests.
  ///
  /// Example :
  /// ```dart
  /// await webhook.update(label: 'My webhook name', avatar: 'assets/images/my_picture.png');
  /// ```
  Future<void> update ({ String? label, String? avatar }) async {
    String? path = avatar != null
      ?  await Helper.getPicture(avatar)
      : this.label;

    Response response = await ioc.use<HttpService>().patch(url: "/webhooks/$id", payload: {
      'label': label ?? this.label,
      'avatar': path,
    });

    if (response.statusCode == 200) {
      if (label != null) _label = label;
      if (avatar != null) _avatar = path;
    }
  }
  /// ### Send a message from the webhook
  ///
  /// Example :
  /// ```dart
  /// await webhook.execute(content: 'Hello World !');
  /// ```
  Future<void> execute ({ String? content, String? username, String? avatarUrl, bool? tts, List<EmbedBuilder>? embeds, List<RowBuilder>? components, bool? suppressEmbed }) async {

    List<dynamic> embedList = [];
    if (embeds != null) {
      for (EmbedBuilder element in embeds) {
        embedList.add(element.toJson());
      }
    }

    List<dynamic> componentList = [];
    if (components != null) {
      for (RowBuilder element in components) {
        componentList.add(element.toJson());
      }
    }

    await ioc.use<HttpService>().post(url: "/webhooks/$id/$token", payload: {
      'username': username,
      'avatar_url': avatarUrl,
      'content': content,
      'embeds': embeds != null ? embedList : [],
      'components': components != null ? componentList : [],
      'tts': tts ?? false,
      'flags': suppressEmbed != null ? MessageFlag.suppressEmbeds.value : null
    });
  }

  /// ### Delete this
  ///
  /// Example :
  /// ```dart
  /// await webhook.delete();
  /// ```
  Future<bool> delete () async {
    Response response = await ioc.use<HttpService>().destroy(url: "/webhooks/$id/$token");

    return response.statusCode == 200;
  }

  factory Webhook.from ({ required dynamic payload }) {
    return Webhook(
      payload['id'],
      payload['type'],
      payload['guild_id'],
      payload['channel_id'],
      payload['user']['id'],
      payload['name'],
      payload['avatar'],
      payload['token'],
      payload['application_id'],
      payload['url'],
      SourceChannel(payload['source_channel']['id'], payload['source_channel']['name']),
      SourceGuild(payload['source_guild']['id'], payload['source_guild']['name'], ImageFormater(payload['source_channel']['icon'], 'icons/${payload['source_guild']['id']}'))
    );
  }
}
