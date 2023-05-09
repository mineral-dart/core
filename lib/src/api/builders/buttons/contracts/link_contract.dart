import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';

abstract class LinkContract extends ButtonContract {
  /// Gets the url of this
  String? get label;

  /// Gets the [EmojiBuilder] of this
  EmojiBuilder? get emoji;

  /// Gets the disabled state of this
  bool get disabled;

  /// Gets the url of this
  String get url;

  /// Sets the label of this
  void setUrl (String value);

  /// Sets the label of this
  void setLabel (String value);

  /// Sets the disabled state of this
  void setDisabled (bool value);

  /// Sets the emoji of this
  void setEmoji (EmojiBuilder value);
}