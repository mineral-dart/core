import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';

abstract class ClickableButtonContract extends ButtonContract {
  String get customId;
  String? get label;
  EmojiBuilder? get emoji;
  bool get disabled;
  ButtonStyle get style;

  void setStyle (ButtonStyle value);
  void setLabel (String value);
  void setDisabled (bool value);
  void setEmoji (EmojiBuilder value);
}