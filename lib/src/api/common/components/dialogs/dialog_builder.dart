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

  DialogBuilder text(String customId, Function(DialogTextInput) fn) {
    final element = DialogElementBuilder.input(customId);
    fn(element);

    final row = RowBuilder()..addComponent(element);

    _elements.add(row);
    return this;
  }

  DialogBuilder paragraph(String customId, Function(DialogParagraphInput) fn) {
    final element = DialogElementBuilder.paragraph(customId);
    fn(element);

    final row = RowBuilder()..addComponent(element);

    _elements.add(row);
    return this;
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
