import 'package:mineral/api.dart';

enum ButtonType implements EnhancedEnum<int> {
  primary(1),
  secondary(2),
  success(3),
  danger(4),
  link(5),
  premium(6);

  @override
  final int value;

  const ButtonType(this.value);
}

final class MessageButton implements Component {
  final ButtonType _type;
  final String? _customId;
  final String? _label;
  final String? _url;
  final PartialEmoji? _emoji;
  final bool _disabled;

  MessageButton({
    required ButtonType type,
    String? customId,
    String? label,
    String? url,
    PartialEmoji? emoji,
    bool? disabled,
  })  : _type = type,
        _customId = customId,
        _label = label,
        _url = url,
        _emoji = emoji,
        _disabled = disabled ?? false;

  factory MessageButton.primary(
    String customId, {
    String? label,
    PartialEmoji? emoji,
    bool? disabled,
  }) {
    return MessageButton(
      type: ButtonType.primary,
      customId: customId,
      label: label,
      emoji: emoji,
      disabled: disabled,
    );
  }

  factory MessageButton.secondary(
    String customId, {
    String? label,
    PartialEmoji? emoji,
    bool? disabled,
  }) {
    return MessageButton(
      type: ButtonType.secondary,
      customId: customId,
      label: label,
      emoji: emoji,
      disabled: disabled,
    );
  }

  factory MessageButton.success(
    String customId, {
    String? label,
    PartialEmoji? emoji,
    bool? disabled,
  }) {
    return MessageButton(
      type: ButtonType.success,
      customId: customId,
      label: label,
      emoji: emoji,
      disabled: disabled,
    );
  }

  factory MessageButton.danger(
    String customId, {
    String? label,
    PartialEmoji? emoji,
    bool? disabled,
  }) {
    return MessageButton(
      type: ButtonType.danger,
      customId: customId,
      label: label,
      emoji: emoji,
      disabled: disabled,
    );
  }

  factory MessageButton.link(
    String url, {
    String? label,
    PartialEmoji? emoji,
    bool? disabled,
  }) {
    return MessageButton(
      type: ButtonType.link,
      url: url,
      label: label,
      emoji: emoji,
      disabled: disabled,
    );
  }

  factory MessageButton.premium(
    String skuId, {
    String? label,
    PartialEmoji? emoji,
    bool? disabled,
  }) {
    return MessageButton(
      type: ButtonType.premium,
      customId: skuId,
      label: label,
      emoji: emoji,
      disabled: disabled,
    );
  }

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
