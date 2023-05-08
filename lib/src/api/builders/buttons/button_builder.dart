import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/clickable_button.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';
import 'package:mineral/src/api/builders/buttons/contracts/clickable_button_contract.dart';
import 'package:mineral/src/api/builders/buttons/link_button.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';

import 'contracts/link_contract.dart';

/// ButtonBuilder component
class ButtonBuilder extends ComponentWrapper implements ButtonContract {
  /// Create a basic button with dedicated properties
  static ClickableButtonContract button (String customId) => ClickableButton(customId, null, ButtonStyle.primary);

  /// Create a link button with dedicated properties
  static LinkContract link (String url) => LinkButton(null, url, ButtonStyle.link);

  final String? _customId;
  String? _label;
  ButtonStyle _style;
  EmojiBuilder? _emoji;
  bool _disabled = false;
  String? _url;

  ButtonBuilder(this._customId, this._url, this._style): super(type: ComponentType.button);

  /// Gets the custom id of this
  String get customId => _customId!;

  /// Gets the label of this
  String? get label => _label;

  /// Gets the [ButtonStyle] of this
  ButtonStyle get style => _style;

  /// Gets the [EmojiBuilder] of this
  EmojiBuilder? get emoji => _emoji;

  /// Gets the disabled state of this
  bool get disabled => _disabled;

  /// Gets the url of this
  String get url => _url!;

  /// Sets the label of this
  void setLabel (String value) => _label = value;

  /// Sets the disabled state of this
  void setDisabled (bool value) => _disabled = value;

  /// Sets the emoji of this
  void setEmoji (EmojiBuilder? value) => _emoji = value;

  /// Sets the style of this
  void setStyle (ButtonStyle value) => _style = value;

  /// Sets the url of this
  void setUrl (String value) => _url = value;

  @override
  Map<String, dynamic> toJson() => {
    'type': type?.value,
    'custom_id': _customId,
    'label': _label,
    'style': _style.value,
    'emoji': _emoji?.emoji.toJson(),
    'disabled': _disabled,
    'url': _url,
  };
}