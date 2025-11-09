import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/components/label.dart';
import 'package:mineral/src/api/common/components/text_display.dart';

final class ModalBuilder {
  final List<ModalComponent> _components = [];

  final String _customId;
  String? _title;

  ModalBuilder(this._customId);

  ModalBuilder addSelectMenu({
    required String customId,
    required String label,
    required SelectMenu menu,
    String? description,
  }) {
    _components.add(
      Label(
        label: label,
        component: menu,
        description: description,
      ),
    );
    return this;
  }

  ModalBuilder addText(String text) {
    _components.add(TextDisplay(text));
    return this;
  }

  ModalBuilder addTextInput({
    required String customId,
    required String label,
    TextInputStyle style = TextInputStyle.short,
    String? placeholder,
    String? value,
    int? minLength,
    int? maxLength,
    bool? isRequired,
    String? description,
  }) {
    final textInput = TextInput(
      customId,
      style: style,
      placeholder: placeholder,
      value: value,
      minLength: minLength,
      maxLength: maxLength,
      isRequired: isRequired,
    );

    _components.add(
      Label(
        label: label,
        component: textInput,
        description: description,
      ),
    );
    return this;
  }

  ModalBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  Map<String, dynamic> build() {
    return {
      'custom_id': _customId,
      'title': _title,
      'components': _components.map((e) => e.toJson()).toList(),
    };
  }
}
