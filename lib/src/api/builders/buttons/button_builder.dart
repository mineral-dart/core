import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/clickable_button.dart';
import 'package:mineral/src/api/builders/buttons/contracts/button_contract.dart';
import 'package:mineral/src/api/builders/buttons/contracts/clickable_button_contract.dart';
import 'package:mineral/src/api/builders/buttons/link_button.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';

import 'contracts/link_contract.dart';

class ButtonBuilder extends ComponentWrapper implements ButtonContract {
  static ClickableButtonContract button (String customId) => ClickableButton(customId, null, ButtonStyle.primary);
  static LinkContract link (String url) => LinkButton(null, url, ButtonStyle.link);

  final String? _customId;
  String? _label;
  ButtonStyle _style;
  EmojiBuilder? _emoji;
  bool _disabled = false;
  String? _url;

  ButtonBuilder(this._customId, this._url, this._style): super(type: ComponentType.button);

  String get customId => _customId!;

  String? get label => _label;

  ButtonStyle get style => _style;

  EmojiBuilder? get emoji => _emoji;

  bool get disabled => _disabled;

  String get url => _url!;

  void setLabel (String value) => _label = value;

  void setDisabled (bool value) => _disabled = value;

  void setEmoji (EmojiBuilder? value) => _emoji = value;

  void setStyle (ButtonStyle value) => _style = value;

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