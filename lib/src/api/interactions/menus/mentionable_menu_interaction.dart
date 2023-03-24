import 'package:mineral/src/api/interactions/menus/select_menu_interaction.dart';

class MentionableMenuInteraction extends SelectMenuInteraction {
  final MenuBucket _menu;

  MentionableMenuInteraction(
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

  factory MentionableMenuInteraction.from(dynamic payload) => MentionableMenuInteraction(
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
  final List<dynamic> _data;

  MenuBucket(this._data);

  /// ### Return an [List] of [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// List<dynamic>? fields = event.interaction.menu.getValues<String>();
  /// ```
  List<dynamic> getValues<T> () => _data;

  /// ### Return the first [T] if this has the designed field
  ///
  /// Example :
  /// ```dart
  /// dynamic field = event.interaction.menu.getValue();
  /// ```
  T? getValue<T>({ int index = 0 }) => _data[index];
}
