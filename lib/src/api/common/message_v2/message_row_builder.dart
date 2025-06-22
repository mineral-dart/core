import 'package:mineral/api.dart';

final class MessageRowBuilder implements MessageComponent {
  final List<MessageComponent> components;

  MessageRowBuilder({this.components = const []});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ComponentType.actionRow.value,
      'components': components.map((e) => e.toJson()).toList(),
    };
  }
}
