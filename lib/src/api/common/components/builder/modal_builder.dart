import 'package:mineral/api.dart';
import 'package:mineral/src/api/common/components/label.dart';
import 'package:mineral/src/api/common/components/text_display.dart';

final class ModalBuilder {
  final List<ModalComponent> _components = [];

  final String _customId;
  String? _title;

  ModalBuilder(this._customId);

  void addLabel({
    required String label,
    required Component component,
    String? description,
  }) {
    _components.add(
      Label(
        label: label,
        component: component,
        description: description,
      ),
    );
  }

  void addText(String text) {
    _components.add(TextDisplay(text));
  }

  ModalBuilder setTitle(String title) {
    _title = title;
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'custom_id': _customId,
      'title': _title,
      'components': _components.map((e) => e.toJson()).toList(),
    };
  }
}
