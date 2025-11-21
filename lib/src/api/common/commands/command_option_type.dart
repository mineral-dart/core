import 'package:mineral/src/api/common/types/enhanced_enum.dart';

/// Defines the data type for command options.
///
/// The [CommandOptionType] enum specifies what kind of input Discord will
/// accept for a command option, determining the validation and UI presentation.
///
/// ## Types
///
/// **Text and Numbers:**
/// - [string]: Any text input
/// - [integer]: Whole numbers only
/// - [double]: Decimal numbers
///
/// **Boolean:**
/// - [boolean]: True/false choice
///
/// **Discord Entities:**
/// - [user]: Server member selection
/// - [channel]: Channel selection (can be restricted by [ChannelType])
/// - [role]: Role selection
/// - [mentionable]: User or role selection
///
/// **Files:**
/// - [attachment]: File upload
///
/// ## Usage
///
/// This enum is used internally by [Option] and [ChoiceOption] factory methods.
/// Most users will not interact with it directly.
///
/// ```dart
/// // Internal usage example
/// Option._('name', 'desc', CommandOptionType.string, null, true)
/// ```
///
/// See also:
/// - [Option] for creating command options
/// - [ChoiceOption] for options with predefined choices
enum CommandOptionType implements EnhancedEnum<int> {
  /// Text input option.
  string(3),
  
  /// Whole number input option.
  integer(4),
  
  /// True/false choice option.
  boolean(5),
  
  /// User selection option.
  user(6),
  
  /// Channel selection option (can be restricted by type).
  channel(7),
  
  /// Role selection option.
  role(8),
  
  /// User or role selection option.
  mentionable(9),
  
  /// Decimal number input option.
  double(10),
  
  /// File upload option.
  attachment(11);

  @override
  final int value;

  const CommandOptionType(this.value);
}
