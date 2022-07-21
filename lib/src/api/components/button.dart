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

class Button extends Component {
  String customId;
  String label;
  ButtonStyle style;
  PartialEmoji? emoji;
  bool disabled;

  Button({ required this.customId, required this.label, required this.style, this.emoji, this.disabled = false }) : super(type: ComponentType.button);

  @override
  dynamic toJson () {
    return {
      'type': type.value,
      'custom_id': customId,
      'label': label,
      'style': style.value,
      'emoji': emoji?.toJson(),
      'disabled': disabled
    };
  }

  factory Button.from({ required dynamic payload }) {
    return Button(
      customId: payload['custom_id'],
      label: payload['label'],
      style: ButtonStyle.values.firstWhere((element) => element.value == payload['style'])
    );
  }
}
