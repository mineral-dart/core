import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';

class PartialEmoji {
  Snowflake id;
  String label;
  bool animated;

  PartialEmoji({ this.id = '', this.label = '', this.animated = false });

  Object toJson () => {
    'id': id == '' ? null : id,
    'name': label,
    'animated': animated,
  };
}

/// Represents an [Emoji] on [Guild] context.
class Emoji extends PartialEmoji {
  GuildMember? creator;
  bool requireColons;
  bool managed;
  bool available;
  EmojiManager manager;

  Emoji({
    required id,
    required label,
    required this.creator,
    required this.requireColons,
    required this.managed,
    required animated,
    required this.available,
    required this.manager,
  }): super(id: id, label: label, animated: animated);

  /// ### Modifies the [label] of this.
  ///
  /// Example :
  /// ```dart
  /// final Emoji? emoji = guild.emojis.cache.get('240561194958716924');
  /// if (emoji != null) {
  ///   await emoji.setLabel('New label');
  /// }
  /// ```
  Future<void> setLabel (String label) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/guilds/${manager.guildId}/emojis/$id", payload: { 'name': label });

    if (response.statusCode == 200) {
      this.label = label;
    }
  }

  /// ### Removes the current this from the [EmojiManager]'s cache
  ///
  /// Example :
  /// ```dart
  /// final Emoji? emoji = guild.emojis.cache.get('240561194958716924');
  /// if (emoji != null) {
  ///   await emoji.delete();
  /// }
  /// ```
  /// You can specify a reason for this action
  ///
  /// Example :
  /// ```dart
  /// await emoji.delete(reason: 'I will destroy this..');
  /// ```
  Future<void> delete () async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.destroy(url: "/guilds/${manager.guildId}/emojis/$id");

    if (response.statusCode == 200) {
      manager.cache.remove(id);
    }
  }

  /// ### Returns this in discord notification format
  ///
  /// Example :
  /// ```dart
  /// final Emoji? emoji = guild.emojis.cache.get('240561194958716924');
  /// if (emoji != null) {
  ///   print(emoji.toString()) // print('<label:240561194958716924>')
  ///   print('$emoji') // print('<label:240561194958716924>')
  /// }
  /// ```
  @override
  String toString () => animated
    ? '<a:$label:$id>'
    : '<$label:$id>';

  factory Emoji.from({ required MemberManager memberManager, required EmojiManager emojiManager, required dynamic payload }) {
    return Emoji(
      id: payload['id'],
      label: payload['name'],
      creator: payload['user'] != null ? memberManager.cache.get(payload['user']['id']) : null,
      requireColons: payload['require_colons'] ?? false,
      managed: payload['managed'] ?? false,
      animated: payload['animated'] ?? false,
      available: payload['available'] ?? false,
      manager: emojiManager
    );
  }
}
