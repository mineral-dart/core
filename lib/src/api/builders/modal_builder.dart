import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_builder.dart';

class ModalBuilder extends ComponentBuilder {
  String label;
  String customId;

  List<RowBuilder>? components = [];

  ModalBuilder({ required this.customId, required this.label, this.components }) : super(type: ComponentType.selectMenu);

  /// ### Created a input text field
  ///
  /// Example :
  /// ```dart
  /// final ModalBuilder modal = ModalBuilder(customId: 'my_modal', label: 'My modal')
  ///   .addInput(customId: 'my_text', label: 'Premier texte');
  /// ```
  ModalBuilder addInput ({ required String customId, required String label, bool? required, int? minLength, int? maxLength, String? placeholder, String? value }) {
    _addInput(customId: customId, label: label, style: TextInputStyle.input, required: required, minLength: minLength, maxLength: maxLength, placeholder: placeholder, value: value);
    return this;
  }

  /// ### Created a input text field with multiple lines
  ///
  /// Example :
  /// ```dart
  /// final ModalBuilder modal = ModalBuilder(customId: 'my_modal', label: 'My modal')
  ///   .addParagraph(customId: 'my_paragraph', label: 'Second texte');
  /// ```
  ModalBuilder addParagraph ({ required String customId, required String label, bool? required, int? minLength, int? maxLength, String? placeholder, String? value }) {
    _addInput(customId: customId, label: label, style: TextInputStyle.paragraph, required: required, minLength: minLength, maxLength: maxLength, placeholder: placeholder, value: value);
    return this;
  }

  void _addInput ({ required String customId, required String label, required TextInputStyle style, bool? required, int? minLength, int? maxLength, String? placeholder, String? value }) {
    components ??= [];

    final TextInputBuilder input = TextInputBuilder(
      customId: customId,
      label: label,
      style: style,
      required: required ?? false,
      minLength: minLength,
      maxLength: maxLength,
      placeholder: placeholder,
      value: value,
    );

    components?.add(RowBuilder.fromComponents([input]));
  }

  @override
  Object toJson() {
    return {
      'title': label,
      'custom_id': customId,
      'components': components?.map((component) => component.toJson()).toList()
    };
  }
}
