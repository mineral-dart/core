import 'package:mineral/api.dart';

/// Represents a horizontal row of components in a message.
///
/// [ActionRow] is a container that organizes components (buttons, select menus)
/// into horizontal rows.
///
/// ## Usage
///
/// ```dart
/// // Row of buttons
/// final buttonRow = ActionRow(components: [
///   Button.success('accept', label: 'Accept'),
///   Button.danger('decline', label: 'Decline'),
///   Button.secondary('later', label: 'Decide Later'),
/// ]);
///
/// // Row with select menu
/// final selectRow = ActionRow(components: [
///   SelectMenu.text('role_select', [
///     SelectMenuOption(label: 'Admin', value: 'admin'),
///     SelectMenuOption(label: 'Moderator', value: 'mod'),
///   ]),
/// ]);
///
/// // Send message with rows
/// await channel.send(
///   MessageBuilder.text('Choose your options:')
///     ..addRow(buttonRow)
///     ..addRow(selectRow),
/// );
/// ```
///
/// ## Component Rules
///
/// - **Buttons**: Up to 5 per row
/// - **Select menus**: 1 per row (takes full width)
/// - Cannot mix different component types in same row
///
/// See also:
/// - [Button] for button components
/// - [SelectMenu] for select menu components
/// - [MessageBuilder] for creating messages with components
final class ActionRow implements MessageComponent {
  /// The components contained in this row.
  final List<Component> components;

  /// Creates an action row with the specified [components].
  ActionRow({this.components = const []});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': ComponentType.actionRow.value,
      'components': components.map((e) => e.toJson()).toList(),
    };
  }
}
