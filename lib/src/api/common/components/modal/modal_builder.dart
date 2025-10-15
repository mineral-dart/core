import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/components/shared/text_display.dart';
import 'modal_label.dart';

final class ModalBuilder {
  final List<Component> _components = [];

  final String _customId;
  String? _title;

  ModalBuilder(this._customId);

  ModalBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  void text(String text) {
    _components.add(TextDisplay(text));
  }

  void label({
    required String label,
    required Component component,
    String? description,
  }) {
    _components.add(
      ModalLabel(
        label: label,
        component: component,
        description: description,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'custom_id': _customId,
      'title': _title,
      'components': _components.map((e) => e.toJson()).toList(),
    };
  }
}
