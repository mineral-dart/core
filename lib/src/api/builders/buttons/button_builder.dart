import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/clickable_button.dart';
import 'package:mineral/src/api/builders/buttons/link_button.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';

/// ButtonBuilder component
class ButtonBuilder extends ComponentWrapper {
  /// Create a basic button with dedicated properties
  static ClickableButton button (String customId, {
    String? label,
    ButtonStyle style = ButtonStyle.primary,
    EmojiBuilder? emoji,
    bool disabled = false,
  }) => ClickableButton(customId, label: label, style: style, emoji: emoji, disabled: disabled);

  /// Create a link button with dedicated properties
  static LinkButton link (String url, {
    String? label,
    EmojiBuilder? emoji,
    bool disabled = false,
  }) => LinkButton(url, label: label, emoji: emoji, disabled: disabled);

  /// Gets the custom id of this
  String? customId;

  /// Gets the label of this
  String? label;

  /// Gets the [ButtonStyle] of this
  ButtonStyle style;

  /// Gets the [EmojiBuilder] of this
  EmojiBuilder? emoji;

  /// Gets the disabled state of this
  bool disabled;

  /// Gets the url of this
  String? url;

  ButtonBuilder(this.customId, {
    this.label,
    this.style = ButtonStyle.primary,
    this.emoji,
    this.disabled = false,
    this.url
  }): super(type: ComponentType.button);


  /// Sets the label of this
  @override
  void setLabel (String value) => label = value;

  /// Sets the disabled state of this
  @override
  void setDisabled (bool value) => disabled = value;

  /// Sets the emoji of this
  @override
  void setEmoji (EmojiBuilder? value) => emoji = value;

  /// Sets the style of this
  void setStyle (ButtonStyle value) => style = value;

  /// Sets the url of this
  void setUrl (String value) => url = value;

  @override
  Map<String, dynamic> toJson() => {
    'type': type?.value,
    'custom_id': customId,
    'label': label,
    'style': style.value,
    'emoji': emoji?.emoji.toJson(),
    'disabled': disabled,
    'url': url,
  };
}