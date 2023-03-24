import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';

class ModalBuilder extends ComponentWrapper {
  String label;
  String customId;

  List<RowBuilder> components = [];

  ModalBuilder(this.customId, this.label);

  /// ### Created a input text field
  ///
  /// Example :
  /// ```dart
  /// final text = TextBuilder('custom_paragraph_id')
  ///   ..setLabel('Foo')
  ///   ..setPlaceholder('Choose a value');
  ///
  /// final ModalBuilder modal = ModalBuilder(customId: 'my_modal', label: 'My modal')
  ///   .text(text);
  /// ```
  void text (TextBuilder builder) {
    components.add(RowBuilder([builder]));
  }

  /// ### Created a input text field with multiple lines
  ///
  /// Example :
  /// ```dart
  /// final paragraph = ParagraphBuilder('custom_text_id')
  ///   ..setLabel('Foo paragraph')
  ///   ..setPlaceholder('Write your Mineral experience');
  ///
  /// final ModalBuilder modal = ModalBuilder(customId: 'my_modal', label: 'My modal')
  ///   .paragraph(paragraph);
  /// ```
  void paragraph (ParagraphBuilder builder) {
    components.add(RowBuilder([builder]));
  }

  @override
  Object toJson() {
    return {
      'title': label,
      'custom_id': customId,
      'components': components.map((component) => component.toJson()).toList()
    };
  }
}
