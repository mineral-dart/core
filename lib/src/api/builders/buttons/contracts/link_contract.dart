import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';

abstract class LinkContract extends ButtonContract {
  String? get label;
  EmojiBuilder? get emoji;
  bool get disabled;
  String get url;

  void setUrl (String value);
  void setLabel (String value);
  void setDisabled (bool value);
  void setEmoji (EmojiBuilder value);
}