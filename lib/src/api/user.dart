import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/dm_channel.dart';
import 'package:mineral/src/api/messages/dm_message.dart';
import 'package:mineral/src/internal/extensions/mineral_client.dart';

class User {
  Snowflake id;
  String username;
  String tag;
  String discriminator;
  bool bot = false;
  int publicFlags;
  String? avatar;
  String? avatarDecoration;
  late Status status;

  User({
    required this.id,
    required this.username,
    required this.tag,
    required this.discriminator,
    required this.bot,
    required this.publicFlags,
    required this.avatar,
    required this.avatarDecoration,
  });

  /// ### Envoie un message en DM à l'utilisateur
  ///
  /// Example :
  /// ```dart
  /// GuildMember? member = guild.members.cache.get('240561194958716924');
  /// await member.user.send(content: 'Hello World !');
  /// ```
  Future<DmMessage?> send ({ String? content, List<MessageEmbed>? embeds, List<Row>? components, bool? tts }) async {
    MineralClient client = ioc.singleton(ioc.services.client);
    Http http = ioc.singleton(ioc.services.http);

    DmChannel? channel = client.dmChannels.cache.get(id);

    /// Get channel if exist or create
    if (channel == null) {
      Response response = await http.post(url: '/users/@me/channels', payload: { 'recipient_id': id });
      if (response.statusCode == 200) {
        channel = DmChannel.from(payload: jsonDecode(response.body));
        client.dmChannels.cache.putIfAbsent(channel.id, () => channel!);
      }
    }

    Response response = await client.sendMessage(channel!,
      content: content,
      embeds: embeds,
      components: components
    );

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      DmMessage message = DmMessage.from(channel: channel, payload: payload);
      channel.messages.cache.putIfAbsent(message.id, () => message);

      return message;
    }
    return null;
  }

  /// ### Returns the absolute url to the user's avatar
  String getDisplayAvatarUrl () {
    return '${Constants.cdnUrl}/avatars/$id/$avatar';
  }

  @override
  String toString () => "<@$id>";

  factory User.from(dynamic payload) {
    return User(
      id: payload['id'],
      username: payload['username'],
      tag: "${payload['username']}#${payload['discriminator']}",
      discriminator: payload['discriminator'],
      bot: payload['bot'] == true,
      publicFlags: payload['public_flags'] ?? 0,
      avatar: payload['avatar'],
      avatarDecoration: payload['avatar_decoration']
    );
  }
}
