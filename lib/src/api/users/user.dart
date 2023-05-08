import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/users/user_flag.dart';
import 'package:mineral/src/internal/mixins/mineral_client.dart';
import 'package:mineral/src/internal/services/console/console_service.dart';
import 'package:mineral_ioc/ioc.dart';

class User {
  Snowflake _id;
  String _username;
  String _discriminator;
  bool _bot;
  bool _system;
  List<UserFlagContract> _publicFlags;
  List<UserFlagContract> _flags;
  UserDecoration _decoration;
  String _lang;
  PremiumType premiumType;

  User(
    this._id,
    this._username,
    this._discriminator,
    this._bot,
    this._system,
    this._publicFlags,
    this._flags,
    this._decoration,
    this._lang,
    this.premiumType
  );

  /// Returns the unique identifier of the user as a [Snowflake].
  Snowflake get id => _id;

  /// Returns the username of the user as a [String].
  String get username => _username;

  /// Returns the username of the user as a [String].
  String get discriminator => _discriminator;

  /// Returns a [boolean] indicating whether the user is a bot.
  bool get isBot => _bot;

  /// Returns a [boolean] indicating whether the user is a system user.
  bool get isSystem => _system;

  /// Returns a list of public user flags as a list of [UserFlagContract].
  List<UserFlagContract> get publicFlags => _publicFlags;

  /// Returns a list of user flags as a list of [UserFlagContract].
  List<UserFlagContract> get flags => _flags;

  /// Returns the decoration of the user as a [UserDecoration].
  UserDecoration get decoration => _decoration;

  /// Returns the user's tag as a [String].
  String get tag => '$_username#$_discriminator';

  /// Returns the user's locale as a [Locale] enum value based on the value of language
  Locale get lang => Locale.values.firstWhere((element) => element.locale == _lang);

  /// Return [GuildMember] of [Guild] context for this
  GuildMember? toGuildMember (Snowflake guildId) {
    MineralClient client = ioc.use<MineralClient>();
    return client.guilds.cache.get(guildId)?.members.cache.get(_id);
  }

  /// This function sends a DM message to the user that corresponds to the instance of the [User].
  ///
  /// ```dart
  /// GuildMember member = guild.members.cache.getOrFail('240561194958716924');
  /// await member.user.send(content: 'Hello World !');
  /// ```
  Future<DmMessage?> send ({ String? content, List<EmbedBuilder>? embeds, ComponentBuilder? components, List<AttachmentBuilder>? attachments, bool? tts }) async {
    MineralClient client = ioc.use<MineralClient>();
    DmChannel? channel = client.dmChannels.cache.get(_id);

    if (channel == null) {
      Response response = await ioc.use<DiscordApiHttpService>().post(url: '/users/@me/channels')
        .payload({ 'recipient_id': _id })
        .build();

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

    final payload = jsonDecode(response.body);

    if (response.statusCode == 200) {
      DmMessage message = DmMessage.from(channel: channel, payload: payload);
      channel.messages.cache.putIfAbsent(message.id, () => message);

      return message;
    }

    ioc.use<ConsoleService>().warn(payload['message']);
    return null;
  }

  /// Returns a taggable [String] representation of the user.
  @override
  String toString () => '<@$_id>';

  factory User.from(dynamic payload) {
    final List<UserFlagContract> publicFlags = [];
    if (payload['public_flags'] != null) {
      for (int element in UserFlag.values) {
        if ((payload['public_flags'] & element) == element) {
          publicFlags.add(UserFlag.find(element));
        }
      }
    }

    final List<UserFlagContract> flags = [];
    if (payload['flags'] != null) {
      for (int element in UserFlag.values) {
        if ((payload['flags'] & element) == element) {
          flags.add(UserFlag.find(element));
        }
      }
    }

    return User(
      payload['id'],
      payload['username'],
      payload['discriminator'],
      payload['bot'] == true,
      payload['system'] == true,
      publicFlags,
      flags,
      UserDecoration(
        payload['discriminator'],
        payload['avatar'] != null ? ImageFormater(payload['avatar'], 'avatars/${payload['id']}') : null,
        payload['avatar_decoration'] != null ? ImageFormater(payload['avatar'], 'avatars/${payload['id']}') : null,
      ),
      payload['locale'] ?? 'en-GB',
      payload['premium_type'] != null
        ? PremiumType.values.firstWhere((element) => element.value == payload['premium_type'])
        : PremiumType.none
    );
  }
}
