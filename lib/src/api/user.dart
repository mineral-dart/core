import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';
import 'package:mineral/src/api/messages/dm_message.dart';
import 'package:mineral/src/internal/mixins/mineral_client.dart';
import 'package:mineral_ioc/ioc.dart';

class User {
  Snowflake _id;
  String _username;
  String _discriminator;
  bool _bot;
  int _publicFlags;
  ImageFormater? _avatar;
  ImageFormater? _avatarDecoration;
  String _lang;
  late Status status;

  User(
    this._id,
    this._username,
    this._discriminator,
    this._bot,
    this._publicFlags,
    this._avatar,
    this._avatarDecoration,
    this._lang,
  );

  Snowflake get id => _id;
  String get username => _username;
  String get discriminator => _discriminator;
  bool get bot => _bot;
  int get publicFlags => _publicFlags;
  ImageFormater? get avatar => _avatar;
  ImageFormater? get avatarDecoration => _avatarDecoration;
  String get tag => '$_username#$_discriminator';
  Locale get lang => Locale.values.firstWhere((element) => element.locale == _lang);


  /// ### Returns the absolute url to the user's avatar
  String get defaultAvatar => _avatar != null
      ? '${Constants.cdnUrl}/avatars/$_id/${_avatar?.url}'
      : '${Constants.cdnUrl}/embed/avatars/${int.parse(_discriminator) % 5 }.png';

  /// Return [GuildMember] of [Guild] context for this
  GuildMember? toGuildMember (Snowflake guildId) {
    MineralClient client = ioc.use<MineralClient>();
    return client.guilds.cache.get(guildId)?.members.cache.get(_id);
  }

  /// ### Envoie un message en DM à l'utilisateur
  ///
  /// Example :
  /// ```dart
  /// GuildMember? member = guild.members.cache.get('240561194958716924');
  /// await member.user.send(content: 'Hello World !');
  /// ```
  Future<DmMessage?> send ({ String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<MessageAttachmentBuilder>? attachments, bool? tts }) async {
    MineralClient client = ioc.use<MineralClient>();
    DmChannel? channel = client.dmChannels.cache.get(_id);

    /// Get channel if exist or create
    if (channel == null) {
      Response response = await ioc.use<HttpService>().post(url: '/users/@me/channels', payload: { 'recipient_id': _id });
      if (response.statusCode == 200) {
        channel = DmChannel.fromPayload(jsonDecode(response.body));
        client.dmChannels.cache.putIfAbsent(channel.id, () => channel!);
      }
    }

    Response response = await client.sendMessage(channel!,
      content: content,
      embeds: embeds,
      components: components,
      attachments: attachments
    );

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      DmMessage message = DmMessage.from(channel: channel, payload: payload);
      channel.messages.cache.putIfAbsent(message.id, () => message);

      return message;
    }
    return null;
  }

  @override
  String toString () => "<@$_id>";

  factory User.from(dynamic payload) {
    return User(
      payload['id'],
      payload['username'],
      payload['discriminator'],
      payload['bot'] == true,
      payload['public_flags'] ?? 0,
      payload['avatar'] != null ? ImageFormater(payload['avatar'], 'avatars/${payload['id']}') : null,
      payload['avatar_decoration'] != null ? ImageFormater(payload['avatar'], 'avatars/${payload['id']}') : null,
      payload['locale'] ?? 'en-GB',
    );
  }
}
