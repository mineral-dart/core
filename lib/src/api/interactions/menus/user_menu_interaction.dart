import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/menus/select_menu_interaction.dart';
import 'package:mineral_ioc/ioc.dart';

import '../../messages/partial_message.dart';

class UserMenuInteraction extends SelectMenuInteraction {
  final MenuBucket _menu;

  UserMenuInteraction(
    super.id,
    super.label,
    super.applicationId,
    super.version,
    super.type,
    super.token,
    super.user,
    super.guild,
    super.message,
    super.customId,
    super.channel,
    this._menu,
  );

  MenuBucket get menu => _menu;

  factory UserMenuInteraction.from(dynamic payload, PartialChannel channel) => UserMenuInteraction(
    payload['id'],
    null,
    payload['application_id'],
    payload['version'],
    payload['type'],
    payload['token'],
    payload['member']?['user']?['id'],
    payload['guild_id'],
    (payload['guild_id'] != null ? Message.from(channel: channel as GuildChannel, payload: payload['message']) : DmMessage.from(channel: channel as DmChannel, payload: payload['message'])) as PartialMessage<PartialChannel>?,
    payload['data']['custom_id'],
    channel,
    MenuBucket(payload['guild_id'], List<String>.from(payload['data']['values'])),
  );
}

class MenuBucket {
  final Snowflake? _guildId;
  final List<Snowflake> _data;

  MenuBucket(this._guildId, this._data);

  /// ### Return an [List] of [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// List<User> users = event.interaction.menu.getUsers();
  /// ```
  List<User> getUsers () => _data
    .map((id) => ioc.use<MineralClient>().users.cache.getOrFail(id))
    .toList();

  /// ### Return an [List] of [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// List<GuildMember> members = event.interaction.menu.getMembers();
  /// ```
  List<GuildMember> getMembers () => _data
    .map((id) => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId).members.cache.getOrFail(id))
    .toList();

  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// User? user = event.interaction.menu.getUser();
  /// User? user = event.interaction.menu.getUser(index: 1);
  /// ```
  User? getUser ({ int index = 0 }) => ioc.use<MineralClient>().users.cache.getOrFail(_data[index]);

  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// GuildMember? user = event.interaction.menu.getMember();
  /// GuildMember? user = event.interaction.menu.getMember(index: 1);
  /// ```
  GuildMember? getMember ({ int index = 0 }) => ioc.use<MineralClient>().guilds.cache
    .getOrFail(_guildId).members.cache
    .getOrFail(_data[index]);
}
