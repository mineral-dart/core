import 'package:collection/collection.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/modal/input_builder.dart';
import 'package:mineral/src/api/builders/modal/text_input_style.dart';
import 'package:mineral_ioc/ioc.dart';

enum ComponentType {
  actionRow(1),
  button(2),
  dynamicSelect(3),
  textInput(4),
  userSelect(5),
  roleSelect(6),
  mentionableSelect(7),
  channelSelect(8);

  final int value;
  const ComponentType(this.value);

  @override
  String toString () => value.toString();
}

abstract class ComponentWrapper {
  ComponentType? type;

  ComponentWrapper({ this.type });

  static wrap (dynamic payload, Snowflake? guildId) {
    final Guild? guild = ioc.use<MineralClient>().guilds.cache.get(guildId);
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

        return ButtonBuilder(payload['custom_id'], payload['url'], style)
          ..setLabel( payload['label'])
          ..setDisabled(payload['disabled'])
          ..setEmoji(emojiBuilder);

      case ComponentType.actionRow:
        return RowBuilder([]);

      case ComponentType.dynamicSelect:
        return DynamicSelectMenuBuilder(payload['custom_id'])
          ..setPlaceholder(payload['placeholder'])
          ..setDisabled(payload['disabled'])
          ..setMinValues(payload['min_values'])
          ..setMaxValues(payload['max_values']);

      case ComponentType.userSelect:
        return UserSelectMenuBuilder(payload['custom_id'])
          ..setPlaceholder(payload['placeholder'])
          ..setDisabled(payload['disabled'])
          ..setMinValues(payload['min_values'])
          ..setMaxValues(payload['max_values']);

      case ComponentType.roleSelect:
        return RoleSelectMenuBuilder(payload['custom_id'])
          ..setPlaceholder(payload['placeholder'])
          ..setDisabled(payload['disabled'])
          ..setMinValues(payload['min_values'])
          ..setMaxValues(payload['max_values']);

      case ComponentType.channelSelect:
        return ChannelSelectMenuBuilder(payload['custom_id'])
          ..setPlaceholder(payload['placeholder'])
          ..setDisabled(payload['disabled'])
          ..setMinValues(payload['min_values'])
          ..setMaxValues(payload['max_values']);

      case ComponentType.mentionableSelect:
        return MentionableSelectMenuBuilder(payload['custom_id'])
          ..setPlaceholder(payload['placeholder'])
          ..setDisabled(payload['disabled'])
          ..setMinValues(payload['min_values'])
          ..setMaxValues(payload['max_values']);

      case ComponentType.textInput:
        late InputBuilder builder;

        switch (payload['style']) {
          case TextInputStyle.input:
            builder = TextBuilder(payload['custom_id']);
            break;
          case TextInputStyle.paragraph:
            builder = ParagraphBuilder(payload['custom_id']);
            break;
        }

        builder
          ..setLabel(payload['label'])
          ..setPlaceholder(payload['placeholder'])
          ..setMaxLength(payload['max_length'])
          ..setMinLength(payload['min_length'])
          ..setRequired(payload['required']);

        builder.value = payload['value'];
    }
  }

  dynamic toJson ();
}
