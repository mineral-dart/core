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
  final List<MessageComponent> _components = [];

  MessageBuilder();

  factory MessageBuilder.text(String text) {
    return MessageBuilder()..addText(text);
  }

  void addButton(Button button) {
    final row = ActionRow(components: [button]);
    _components.add(row);
  }

  void addButtons(List<Button> buttons) {
    if (buttons.length > 5) {
      throw ArgumentError.value(
        buttons.length,
        'buttons',
        'A row can contain at most 5 buttons (received ${buttons.length}).',
      );
    }

    final row = ActionRow(components: buttons);
    _components.add(row);
  }

  void addContainer({
    required MessageBuilder builder,
    Color? color,
    bool? spoiler,
  }) {
    _components.add(Container(color, spoiler, builder));
  }

  void addFile(AttachedFile file) {
    _components.add(file);
  }

  void addGallery(MediaGallery gallery) {
    _components.add(gallery);
  }

  void addSection(Section section) {
    for (final component in section.builder._components) {
      if (component is! TextDisplay) {
        throw FormatException('Section components must be text only');
      }
    }

    _components.add(section);
  }

  void addSelectMenu(SelectMenu menu) {
    final row = ActionRow(components: [menu]);
    _components.add(row);
  }

  void addSeparator(
      {bool show = true, SeparatorSize spacing = SeparatorSize.small}) {
    _components.add(Separator(show, spacing));
  }

  void addText(String text) {
    _components.add(TextDisplay(text));
  }

  void appendFrom(MessageBuilder builder) {
    _components.addAll(builder._components);
  }

  List<Map<String, dynamic>> build() {
    return _components.map((e) => e.toJson()).toList();
  }

  MessageBuilder copy() {
    return MessageBuilder().._components.addAll(_components);
  }

  MessageBuilder copyWith(MessageBuilder builder) {
    return MessageBuilder()
      .._components.addAll(_components)
      .._components.addAll(builder._components);
  }

  void prependFrom(MessageBuilder builder) {
    _components.insertAll(0, builder._components);
  }
}
