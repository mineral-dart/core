import 'package:mineral/api.dart';
import 'package:mineral/src/api/components/component.dart';

enum ButtonStyle {
  primary(1),
  secondary(2),
  success(3),
  danger(4),
  link(5);

  final int value;
  const ButtonStyle(this.value);

  @override
  String toString () => value.toString();
}

class ButtonBuilder extends Component {
  String? _customId;
  String? _label;
  ButtonStyle _style;
  EmojiBuilder? _emoji;
  bool _disabled = false;
  String? _url;

  ButtonBuilder(this._customId, this._label, this._style, this._emoji, this._disabled, this._url) : super(type: ComponentType.button);

  @override
  dynamic toJson () {
    return {
      'type': type.value,
      'custom_id': _customId,
      'label': _label,
      'style': _style.value,
      'emoji': _emoji?.emoji.toJson(),
      'disabled': _disabled,
      'url': _url,
    };
  }

  factory ButtonBuilder.fromButton({ required String customId, required ButtonStyle style, String? label, EmojiBuilder? emoji, bool disabled = false }) {
    return ButtonBuilder(customId, label, style, emoji, disabled, null);
  }

  factory ButtonBuilder.fromLink({ required String url, String? label, EmojiBuilder? emoji, bool disabled = false }) {
    return ButtonBuilder(null, label, ButtonStyle.link, emoji, disabled, url);
  }
}
