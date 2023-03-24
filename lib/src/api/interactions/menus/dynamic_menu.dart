import 'package:mineral/src/api/interactions/menus/select_menu_interaction.dart';

class DynamicMenu extends SelectMenuInteraction {
  final MenuBucket _menu;

  DynamicMenu(
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
    super.channelId,
    this._menu,
  );

  MenuBucket get menu => _menu;

  factory DynamicMenu.from(dynamic payload) => DynamicMenu(
    payload['id'],
    null,
    payload['application_id'],
    payload['version'],
    payload['type'],
    payload['token'],
    payload['member']?['user']?['id'],
    payload['guild_id'],
    payload['message']?['id'],
    payload['data']['custom_id'],
    payload['channel_id'],
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
  T getValue<T>({ int index = 0 }) => _data[index];
}
