import 'package:mineral/src/api/common/components/buttons/button_type.dart';
import 'package:mineral/src/api/common/components/component_type.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/partial_emoji.dart';

final class MessageButton implements MessageComponent {
  final ButtonType _type;
  final String? _customId;
  final String? _label;
  final String? _url;
  final PartialEmoji? _emoji;
  final bool _disabled;

  MessageButton(
      {required ButtonType type,
      String? customId,
      String? label,
      String? url,
      PartialEmoji? emoji,
      bool? disabled})
      : _type = type,
        _customId = customId,
        _label = label,
        _url = url,
        _emoji = emoji,
        _disabled = disabled ?? false;

  factory MessageButton.primary(String customId,
          {String? label, PartialEmoji? emoji, bool? disabled}) =>
      MessageButton(
          type: ButtonType.primary,
          customId: customId,
          label: label,
          emoji: emoji,
          disabled: disabled);

  factory MessageButton.secondary(String customId,
          {String? label, PartialEmoji? emoji, bool? disabled}) =>
      MessageButton(
          type: ButtonType.secondary,
          customId: customId,
          label: label,
          emoji: emoji,
          disabled: disabled);

  factory MessageButton.success(String customId,
          {String? label, PartialEmoji? emoji, bool? disabled}) =>
      MessageButton(
          type: ButtonType.success,
          customId: customId,
          label: label,
          emoji: emoji,
          disabled: disabled);

  factory MessageButton.danger(String customId,
          {String? label, PartialEmoji? emoji, bool? disabled}) =>
      MessageButton(
          type: ButtonType.danger,
          customId: customId,
          label: label,
          emoji: emoji,
          disabled: disabled);

  factory MessageButton.link(String url,
          {String? label, PartialEmoji? emoji, bool? disabled}) =>
      MessageButton(
          type: ButtonType.link,
          url: url,
          label: label,
          emoji: emoji,
          disabled: disabled);

  factory MessageButton.premium(String skuId,
          {String? label, PartialEmoji? emoji, bool? disabled}) =>
      MessageButton(
          type: ButtonType.premium,
          customId: skuId,
          label: label,
          emoji: emoji,
          disabled: disabled);

  @override
  Map<String, dynamic> toJson() {
    return {
      'custom_id': _customId,
      'type': ComponentType.button.value,
      'style': _type.value,
      if (_url != null) 'url': _url,
      if (_label != null) 'label': _label,
      if (_disabled) 'disabled': _disabled,
      if (_emoji != null)
        'emoji': {
          'name': _emoji.name,
          'id': _emoji.id,
          'animated': _emoji.animated,
        },
    };
  }
}
