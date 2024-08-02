import 'package:mineral/api/common/components/buttons/button_type.dart';
import 'package:mineral/api/common/partial_emoji.dart';

final class ButtonBuilder {
  static BasicButtonBuilder primary(String customId) =>
      BasicButtonBuilder(ButtonType.primary, customId);

  static BasicButtonBuilder secondary(String customId) =>
      BasicButtonBuilder(ButtonType.secondary, customId);

  static BasicButtonBuilder success(String customId) =>
      BasicButtonBuilder(ButtonType.success, customId);

  static BasicButtonBuilder danger(String customId) =>
      BasicButtonBuilder(ButtonType.danger, customId);

  static LinkButtonBuilder link() => LinkButtonBuilder();

  static PremiumButtonBuilder premium(String skuId) => PremiumButtonBuilder(skuId);
}

final class BasicButtonBuilder with ButtonImpl {
  final ButtonType _type;
  final String _customId;

  BasicButtonBuilder(this._type, this._customId);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'custom_id': _customId,
      'type': _type.value,
    };
  }
}

final class PremiumButtonBuilder {
  final ButtonType _type = ButtonType.premium;
  final String _skuId;

  PremiumButtonBuilder(this._skuId);

  Map<String, dynamic> toJson() {
    return {
      'type': _type.value,
      'sku_id': _skuId,
    };
  }
}

final class LinkButtonBuilder with ButtonImpl {
  final ButtonType _type = ButtonType.link;
  String? _url;

  LinkButtonBuilder setUrl(String url) {
    _url = url;
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': _type.value,
      'url': _url,
    };
  }
}

mixin ButtonImpl {
  String? _label;
  PartialEmoji? _emoji;
  bool _disabled = false;

  T setLabel<T>(String label) {
    _label = label;
    return this as T;
  }

  T setEmoji<T>(PartialEmoji emoji) {
    _emoji = emoji;
    return this as T;
  }

  T setDisabled<T>(bool disabled) {
    _disabled = disabled;
    return this as T;
  }

  Map<String, dynamic> toJson() {
    return {
      'label': _label,
      'disabled': _disabled,
      if (_emoji != null)
        'emoji': {
          'name': _emoji?.name,
          'id': _emoji?.id,
          'animated': _emoji?.animated,
        },
    };
  }
}
