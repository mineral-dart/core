import 'package:mineral/src/api/common/components/dialogs/dialog_element.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/components/row_builder.dart';

final class DialogBuilder implements MessageComponent {
  final List<MessageComponent> _elements = [];

  final String _customId;
  String? _title;

  DialogBuilder(this._customId);

  DialogBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  void text(
      {required String customId,
      required String title,
      String? placeholder,
      String? defaultValue,
      DialogFieldConstraint? constraint}) {
    final element = DialogElementBuilder.input(customId);

    if (placeholder != null) {
      element.setPlaceholder(placeholder);
    }

    if (defaultValue != null) {
      element.setDefaultValue(defaultValue);
    }

    if (constraint != null) {
      element.setConstraint(
        maxLength: constraint.maxLength,
        minLength: constraint.minLength,
        required: constraint.required,
      );
    }

    element.setLabel(title);

    final row = RowBuilder()..addComponent(element);

    _elements.add(row);
  }

  void paragraph(
      {required String customId,
      required String title,
      String? placeholder,
      String? defaultValue,
      DialogFieldConstraint? constraint}) {
    final element = DialogElementBuilder.paragraph(customId);

    if (placeholder != null) {
      element.setPlaceholder(placeholder);
    }

    if (defaultValue != null) {
      element.setDefaultValue(defaultValue);
    }

    if (constraint != null) {
      element.setConstraint(
        maxLength: constraint.maxLength,
        minLength: constraint.minLength,
        required: constraint.required,
      );
    }

    element.setLabel(title);

    final row = RowBuilder()..addComponent(element);

    _elements.add(row);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'custom_id': _customId,
      'title': _title,
      'components': _elements.map((e) => e.toJson()).toList(),
    };
  }
}
