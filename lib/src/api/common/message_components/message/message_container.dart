import 'package:mineral/api.dart';

final class MessageContainer implements Component {
  ComponentType get type => ComponentType.container;

  final Color? _color;
  final bool? _spoiler;
  final MessageComponentBuilder? _components;

  MessageContainer(this._color, this._spoiler, this._components);

  @override
  Map<String, dynamic> toJson() {
    final components = _components?.build() ?? [];

    if (components.any((e) => e['type'] == ComponentType.container.value)) {
      throw FormatException('Container cannot contain another container');
    }

    return {
      'type': type.value,
      'accent_color': _color?.toInt(),
      'spoiler': _spoiler ?? false,
      'components': components,
    };
  }
}
