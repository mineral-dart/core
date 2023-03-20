import 'package:mineral/core/builders.dart';

abstract class LinkContract {
  String? get label;
  EmojiBuilder? get emoji;
  bool get disabled;
  String get url;

  void setUrl (String value);
  void setLabel (String value);
  void setDisabled (bool value);
  void setEmoji (EmojiBuilder value);
}