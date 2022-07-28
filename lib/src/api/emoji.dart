import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';

class PartialEmoji {
  final Snowflake _id;
  String _label;
  final bool _animated;

  PartialEmoji(this._id, this._label, this._animated);

  Snowflake get id => _id;
  String get label => _label;
  bool get isAnimated => _animated;

  Object toJson () => {
    'id': _id == '' ? null : _id,
    'name': _label,
    'animated': _animated,
  };
}

/// Represents an [Emoji] on [Guild] context.
class Emoji extends PartialEmoji {
  GuildMember? _creator;
  bool _requireColons;
  bool _managed;
  bool _available;
  EmojiManager _manager;

  Emoji(
    super._id,
    super._label,
    super._animated,
    this._creator,
    this._requireColons,
    this._managed,
    this._available,
    this._manager,
  );

  GuildMember? get creator => _creator;
  bool get requireColons => _requireColons;
  bool get managed => _managed;
  bool get available => _available;
  EmojiManager get manager => _manager;

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
    Response response = await http.patch(url: "/guilds/${manager.guild.id}/emojis/$id", payload: { 'name': label });

    if (response.statusCode == 200) {
      _label = label;
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
    Response response = await http.destroy(url: "/guilds/${manager.guild.id}/emojis/$id");

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
  String toString () => isAnimated
    ? '<a:$label:$id>'
    : '<$label:$id>';

  factory Emoji.from({ required MemberManager memberManager, required EmojiManager emojiManager, required dynamic payload }) {
    return Emoji(
      payload['id'],
      payload['name'],
      payload['animated'] ?? false,
      payload['user'] != null ? memberManager.cache.get(payload['user']['id']) : null,
      payload['require_colons'] ?? false,
      payload['managed'] ?? false,
      payload['available'] ?? false,
      emojiManager
    );
  }
}
