import 'package:mineral/core/builders.dart';

abstract class ButtonContract {
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