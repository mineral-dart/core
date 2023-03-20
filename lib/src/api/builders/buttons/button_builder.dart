import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';
import 'package:mineral/src/api/builders/component_builder.dart';

import 'contracts/link_contract.dart';

class ButtonBuilder extends ComponentBuilder {
  static ButtonContract button (String customId) => ButtonBuilder(customId, ButtonStyle.primary) as ButtonContract;
  static LinkContract link (String url) => ButtonBuilder(null, ButtonStyle.link) as LinkContract;

  final String? customId;
  String? label;
  ButtonStyle style;
  EmojiBuilder? emoji;
  bool disabled = false;
  String? url;

  ButtonBuilder(this.customId, this.style): super(type: ComponentType.button);

  void setLabel (String value) => label = value;
  void setDisabled (bool value) => disabled = value;
  void setEmoji (EmojiBuilder? value) => emoji = value;
  void setStyle (ButtonStyle value) => style = value;

  @override
  Map<String, dynamic> toJson() => {
    'type': type.value,
    'custom_id': customId,
    'label': label,
    'style': style.value,
    'emoji': emoji?.emoji.toJson(),
    'disabled': disabled,
    'url': url,
  };
}