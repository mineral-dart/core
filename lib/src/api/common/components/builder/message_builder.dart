import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/components/container.dart';
import 'package:mineral/src/api/common/components/text_display.dart';

/// ```dart
/// {@template message_builder}
/// final buttons = [
///   MessageButton.primary('primary', label: 'label'),
///   MessageButton.secondary('secondary', label: 'label'),
///   MessageButton.danger('danger', label: 'label'),
///   MessageButton.link('https://google.com', label: 'label'),
/// ];
///
/// final channelSelectMenu = SelectMenu.channel('channel',
///   channelTypes: [ChannelType.guildText],
///   defaultValues: [Snowflake.parse('1322554770057068636')]);
///
/// final builder = MessageBuilder()
///   ..text('# Hello from World')
///   ..separator()
///   ..text('Hello from ${message.channelId}')
///   ..file(Attachment.path('assets/logo.png'))
///   ..file(await Attachment.network('https://i.redd.it/d2hd73xxwvaa1.jpg'));
/// {@endtemplate}
/// ```
final class MessageBuilder {
  final List<Component> _components = [];

  void text(String text) {
    _components.add(TextDisplay(text));
  }

  void separator(
      {bool show = true, SeparatorSize spacing = SeparatorSize.small}) {
    _components.add(Separator(show, spacing));
  }

  void container({
    required MessageBuilder builder,
    Color? color,
    bool? spoiler,
  }) {
    _components.add(Container(color, spoiler, builder));
  }

  void button(Button button) {
    if (_components.length > 5) {
      throw Exception('You can only add up to 5 buttons to a message');
    }

    final row = ActionRow(components: [button]);
    _components.add(row);
  }

  void buttons(List<Button> buttons) {
    final row = ActionRow(components: buttons);
    _components.add(row);
  }

  void selectMenu(SelectMenu menu) {
    final row = ActionRow(components: [menu]);
    _components.add(row);
  }

  void section(Section section) {
    for (final component in section.builder._components) {
      if (component is! TextDisplay) {
        throw FormatException('Section components must be text only');
      }
    }

    _components.add(section);
  }

  void gallery(MediaGallery gallery) {
    _components.add(gallery);
  }

  void file(AttachedFile file) {
    _components.add(file);
  }

  List<Map<String, dynamic>> build() {
    return _components.map((e) => e.toJson()).toList();
  }

  void prepend(MessageBuilder builder) {
    _components.insertAll(0, builder._components);
  }

  void append(MessageBuilder builder) {
    _components.addAll(builder._components);
  }

  MessageBuilder clone() {
    return MessageBuilder().._components.addAll(_components);
  }

  MessageBuilder cloneFrom(MessageBuilder builder) {
    return MessageBuilder()
      .._components.addAll(_components)
      .._components.addAll(builder._components);
  }
}
