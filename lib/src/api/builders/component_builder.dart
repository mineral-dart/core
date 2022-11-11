import 'package:collection/collection.dart';
import 'package:mineral/api.dart';
import 'package:mineral/builders.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/builders/emoji_builder.dart';

enum ComponentType {
  actionRow(1),
  button(2),
  selectMenu(3),
  textInput(4);

  final int value;
  const ComponentType(this.value);

  @override
  String toString () => value.toString();
}

abstract class ComponentBuilder {
  ComponentType type;

  ComponentBuilder({ required this.type });

  static wrap (dynamic payload, Snowflake? guildId) {
    final Guild? guild = ioc.singleton<MineralClient>(Service.client).guilds.cache.get(guildId);
    final componentType = ComponentType.values.firstWhereOrNull((element) => element.value == payload['type']);

    if (componentType == null) {
      return;
    }

    switch (componentType) {
      case ComponentType.button:
        final ButtonStyle style = ButtonStyle.values.firstWhere((element) => element.value == payload['style']);
        final EmojiBuilder? emojiBuilder = guild != null && payload['id'] != null
          ? EmojiBuilder.fromEmoji(guild.emojis.cache.getOrFail(payload['id']))
          : EmojiBuilder.fromUnicode(payload['emoji']?['name']);

        return ButtonBuilder(payload['custom_id'], payload['label'], style, emojiBuilder, payload['disabled'], payload['url']);
      case ComponentType.actionRow:
        return RowBuilder();
      case ComponentType.selectMenu:
        return SelectMenuBuilder(
          customId: payload['custom_id'],
          options: [],
          placeholder: payload['placeholder'],
          disabled: payload['disabled'],
          minValues: payload['min_values'],
          maxValues: payload['max_values'],
        );
      case ComponentType.textInput:
        return TextInputBuilder(
          customId: payload['custom_id'],
          label: payload['label'],
          style: TextInputStyle.values.firstWhere((element) => element.value == payload['style']),
          placeholder: payload['placeholder'],
          required: payload['required'],
          maxLength: payload['max_length'],
          minLength: payload['min_length'],
          value: payload['value'],
        );
    }
  }

  dynamic toJson ();
}
