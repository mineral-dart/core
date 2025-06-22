import 'package:mineral/api.dart';

final class MessageText implements MessageComponent {
  ComponentType get type => ComponentType.textDisplay;

  final String _content;

  MessageText(this._content);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'content': _content,
    };
  }
}
