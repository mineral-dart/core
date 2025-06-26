import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/message_v2/message_container.dart';
import 'package:mineral/src/api/common/message_v2/message_separator.dart';
import 'package:mineral/src/api/common/message_v2/message_text.dart';

final class MessageComponentBuilder {
  final List<MessageComponent> _components = [];

  void text(String text) {
    _components.add(MessageText(text));
  }

  void separator(
      {bool show = true, SeparatorSize spacing = SeparatorSize.small}) {
    _components.add(MessageSeparator(show, spacing));
  }

  void container({
    required MessageComponentBuilder builder,
    Color? color,
    bool? spoiler,
  }) {
    _components.add(MessageContainer(color, spoiler, builder));
  }

  void button(MessageButton button) {
    if (_components.isEmpty) {
      return;
    }

    if (_components.length > 5) {
      throw Exception('You can only add up to 5 buttons to a message');
    }

    final row = MessageRowBuilder(components: [button]);
    _components.add(row);
  }

  void buttons(List<MessageButton> buttons) {
    final row = MessageRowBuilder(components: buttons);
    _components.add(row);
  }

  void selectMenu(MessageMenu menu) {
    final row = MessageRowBuilder(components: [menu]);
    _components.add(row);
  }

  void section(MessageSection section) {
    for (final component in section.builder._components) {
      if (component is! MessageText) {
        throw FormatException('Section components must be text only');
      }
    }

    _components.add(section);
  }

  void gallery(MessageGallery gallery) {
    _components.add(gallery);
  }

  void file(Attachment file) {
    _components.add(file);
  }

  List<Map<String, dynamic>> build() {
    return _components.map((e) => e.toJson()).toList();
  }
}
