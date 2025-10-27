import 'package:mineral/api.dart';

final class TextDisplay implements Component {
  ComponentType get type => ComponentType.textDisplay;

  final String _content;

  TextDisplay(this._content);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'content': _content,
    };
  }
}
