import 'package:mineral/api.dart';

final class ActionRow implements MessageComponent {
  final List<Component> components;

  ActionRow({this.components = const []});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ComponentType.actionRow.value,
      'components': components.map((e) => e.toJson()).toList(),
    };
  }
}
