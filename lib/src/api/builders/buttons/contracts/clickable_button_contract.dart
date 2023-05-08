import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';

abstract class ClickableButtonContract extends ButtonContract {
  /// Gets the custom id of this
  String get customId;

  /// Gets the label of this
  String? get label;

  /// Gets the [EmojiBuilder] of this
  EmojiBuilder? get emoji;

  /// Gets the disabled state of this
  bool get disabled;

  /// Sets the [ButtonStyle] of this
  ButtonStyle get style;

  /// Sets the [ButtonStyle] of this
  void setStyle (ButtonStyle value);

  /// Sets the label of this
  void setLabel (String value);

  /// Sets the disabled state of this
  void setDisabled (bool value);

  /// Sets the emoji of this
  void setEmoji (EmojiBuilder value);
}