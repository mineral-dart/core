import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/components/text_input.dart';

import '../../../api.dart';

class Modal extends Component {
  String label;
  String customId;

  List<Row> components = [];

  Modal({ required this.customId, required this.label }) : super(type: ComponentType.selectMenu);

  /// ### Created a input text field
  ///
  /// Example :
  /// ```dart
  /// final Modal modal = Modal(customId: 'my_modal', label: 'My modal')
  ///   .addInput(customId: 'my_text', label: 'Premier texte');
  /// ```
  Modal addInput ({ required String customId, required String label, bool? required, int? minLength, int? maxLength, String? placeholder, String? value }) {
    _addInput(customId: customId, label: label, style: TextInputStyle.short, required: required, minLength: minLength, maxLength: maxLength, placeholder: placeholder, value: value);
    return this;
  }

  /// ### Created a input text field with multiple lines
  ///
  /// Example :
  /// ```dart
  /// final Modal modal = Modal(customId: 'my_modal', label: 'My modal')
  ///   .addParagraph(customId: 'my_paragraph', label: 'Second texte');
  /// ```
  Modal addParagraph ({ required String customId, required String label, bool? required, int? minLength, int? maxLength, String? placeholder, String? value }) {
    _addInput(customId: customId, label: label, style: TextInputStyle.paragraph, required: required, minLength: minLength, maxLength: maxLength, placeholder: placeholder, value: value);
    return this;
  }

  void _addInput ({ required String customId, required String label, required TextInputStyle style, bool? required, int? minLength, int? maxLength, String? placeholder, String? value }) {
    TextInput input = TextInput(
      customId: customId,
      label: label,
      style: style,
      required: required ?? false,
      minLength: minLength,
      maxLength: maxLength,
      placeholder: placeholder,
      value: value,
    );

    components.add(Row(components: [input]));
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
