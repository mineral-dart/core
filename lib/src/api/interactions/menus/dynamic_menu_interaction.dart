import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/interactions/menus/select_menu_interaction.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class DynamicMenuInteraction extends SelectMenuInteraction {
  final MenuBucket _menu;

  DynamicMenuInteraction(
    super.id,
    super.label,
    super.applicationId,
    super.version,
    super.type,
    super.token,
    super.user,
    super.guild,
    super.messageId,
    super.customId,
    super.channel,
    this._menu,
  );

  MenuBucket get menu => _menu;

  factory DynamicMenuInteraction.from(dynamic payload, PartialChannel channel) => DynamicMenuInteraction(
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
    MenuBucket(payload['data']['values']),
  );
}

class MenuBucket {
  final List _data;

  MenuBucket(this._data);

  /// ### Return an [List] of [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// List<String>? fields = event.interaction.menu.getValues<String>();
  /// List<int>? fields = event.interaction.menu.getValues<int>();
  /// ```
  List<T> getValues<T> () => List<T>.from(_data);

  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// String? field = event.interaction.menu.getValue<String>();
  /// int? field = event.interaction.menu.getValue<int>();
  /// ```
  T? getValue<T>({ int index = 0 }) => _data[index];
}
