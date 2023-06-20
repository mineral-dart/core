import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/menus/select_menu_interaction.dart';
import 'package:mineral_ioc/ioc.dart';

import '../../messages/partial_message.dart';

class RoleMenuInteraction extends SelectMenuInteraction {
  final MenuBucket _menu;

  RoleMenuInteraction(
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

  factory RoleMenuInteraction.from(dynamic payload, PartialChannel channel) => RoleMenuInteraction(
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
  /// List<Role> roles = event.interaction.menu.getRoles();
  /// ```
  List<Role> getRoles () => _data
    .map((id) => ioc.use<MineralClient>().guilds.cache.getOrFail(_guildId).roles.cache.getOrFail(id))
    .toList();

  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// GuildMember? user = event.interaction.menu.getMember();
  /// GuildMember? user = event.interaction.menu.getMember(index: 1);
  /// ```
  Role? getRole ({ int index = 0 }) => ioc.use<MineralClient>().guilds.cache
    .getOrFail(_guildId).roles.cache
    .getOrFail(_data[index]);
}
