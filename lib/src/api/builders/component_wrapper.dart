import 'package:collection/collection.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_ioc/ioc.dart';

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

abstract class ComponentWrapper {
  ComponentType type;

  ComponentWrapper({ required this.type });

  static wrap (dynamic payload, Snowflake? guildId) {
    final Guild? guild = ioc.use<MineralClient>().guilds.cache.get(guildId);
    final componentType = ComponentType.values.firstWhereOrNull((element) => element.value == payload['type']);

    print(componentType);

    if (componentType == null) {
      return;
    }

    switch (componentType) {
      case ComponentType.button:
        final ButtonStyle style = ButtonStyle.values.firstWhere((element) => element.value == payload['style']);
        final EmojiBuilder? emojiBuilder = guild != null && payload['id'] != null
          ? EmojiBuilder.fromEmoji(guild.emojis.cache.getOrFail(payload['id']))
          : EmojiBuilder.fromUnicode(payload['emoji']?['name']);

        return ButtonBuilder(payload['custom_id'], payload['url'], style)
          ..setLabel( payload['label'])
          ..setDisabled(payload['disabled'])
          ..setEmoji(emojiBuilder);

      case ComponentType.actionRow:
        return RowBuilder([]);
      case ComponentType.selectMenu:
        return SelectMenuBuilder(payload['custom_id'])
          ..setPlaceholder(payload['placeholder'])
          ..setDisabled(payload['disabled'])
          ..setMinValues(payload['min_values'])
          ..setMaxValues(payload['max_values']);
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
