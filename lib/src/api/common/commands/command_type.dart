import 'package:mineral/src/api/common/types/enhanced_enum.dart';

/// Defines the internal Discord command structure type.
///
/// The [CommandType] enum represents the structural types used internally
/// by Discord's API to distinguish between subcommands and subcommand groups.
///
/// ## Usage
///
/// This enum is primarily used internally by the framework. Most users will
/// not interact with it directly, as the builders handle this automatically.
///
/// - [subCommand]: Individual executable subcommand
/// - [subCommandGroup]: Group containing multiple subcommands
///
/// See also:
/// - [SubCommandBuilder] for creating subcommands
/// - [CommandGroupBuilder] for creating command groups
enum CommandType implements EnhancedEnum<int> {
  /// Individual executable subcommand.
  ///
  /// Represents a single subcommand within a parent command or group.
  subCommand(1),
  
  /// Group containing multiple subcommands.
  ///
  /// Represents a logical grouping of related subcommands.
  subCommandGroup(2);

  @override
  final int value;

  const CommandType(this.value);
}
