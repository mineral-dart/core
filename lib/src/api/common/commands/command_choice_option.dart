import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/commands/command_option_type.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';

/// A command option with predefined choices that users can select from.
///
/// The [ChoiceOption] allows you to restrict user input to a specific set of
/// predefined values, creating a dropdown menu in Discord's command interface.
/// This is useful when you want users to select from a known list of options
/// rather than providing free-form input.
///
/// ## Supported Types
///
/// - **String choices**: Text-based options
/// - **Integer choices**: Whole number options
/// - **Double choices**: Decimal number options
///
/// ## Usage
///
/// ### String Choices
///
/// ```dart
/// command.addOption(ChoiceOption.string(
///   name: 'category',
///   description: 'Select a category',
///   required: true,
///   choices: [
///     Choice('Electronics', 'electronics'),
///     Choice('Clothing', 'clothing'),
///     Choice('Food', 'food'),
///   ],
/// ));
///
/// // Handler
/// void handle(CommandContext ctx, {required String category}) {
///   // category will be: 'electronics', 'clothing', or 'food'
/// }
/// ```
///
/// ### Integer Choices
///
/// ```dart
/// command.addOption(ChoiceOption.integer(
///   name: 'difficulty',
///   description: 'Select difficulty level',
///   required: true,
///   choices: [
///     Choice('Easy', 1),
///     Choice('Medium', 2),
///     Choice('Hard', 3),
///   ],
/// ));
///
/// // Handler
/// void handle(CommandContext ctx, {required int difficulty}) {
///   // difficulty will be: 1, 2, or 3
/// }
/// ```
///
/// ### Double Choices
///
/// ```dart
/// command.addOption(ChoiceOption.double(
///   name: 'multiplier',
///   description: 'Select bonus multiplier',
///   required: false,
///   choices: [
///     Choice('1.5x', 1.5),
///     Choice('2x', 2.0),
///     Choice('2.5x', 2.5),
///   ],
/// ));
///
/// // Handler
/// void handle(CommandContext ctx, {double? multiplier}) {
///   final mult = multiplier ?? 1.0;
/// }
/// ```
///
/// ### Complex Example
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('ticket')
///   ..setDescription('Create a support ticket')
///   ..addOption(ChoiceOption.string(
///     name: 'type',
///     description: 'Ticket type',
///     required: true,
///     choices: [
///       Choice('🐛 Bug Report', 'bug'),
///       Choice('✨ Feature Request', 'feature'),
///       Choice('❓ Question', 'question'),
///       Choice('💬 Other', 'other'),
///     ],
///   ))
///   ..addOption(ChoiceOption.integer(
///     name: 'priority',
///     description: 'Priority level',
///     required: false,
///     choices: [
///       Choice('🔴 Critical', 1),
///       Choice('🟠 High', 2),
///       Choice('🟡 Medium', 3),
///       Choice('🟢 Low', 4),
///     ],
///   ))
///   ..handle((CommandContext ctx, {required String type, int? priority}) {
///     final priorityLevel = priority ?? 3;
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Ticket created: $type (Priority: $priorityLevel)'),
///     );
///   });
/// ```
///
/// ## Choice Names vs Values
///
/// - **Name**: What users see in Discord's interface (can include emojis, spaces)
/// - **Value**: What your handler receives (should be simple, lowercase identifiers)
///
/// ```dart
/// Choice('👑 Premium Plan', 'premium'),  // User sees "👑 Premium Plan"
///                                          // Handler gets "premium"
/// ```
///
/// ## Limitations
///
/// - Maximum 25 choices per option
/// - Choice names must be 1-100 characters
/// - Choice values (strings) must be 1-100 characters
/// - Choice values must be unique within the option
///
/// ## Best Practices
///
/// - **Keep it simple**: Don't overwhelm users with too many choices
/// - **Clear names**: Use descriptive, easy-to-understand choice names
/// - **Logical ordering**: Order choices in a logical way (alphabetical, by priority, etc.)
/// - **Use emojis**: Add visual indicators to choice names for better UX
/// - **Consistent values**: Use lowercase, hyphenated values for consistency
/// - **Consider optional**: Make choices optional when appropriate with sensible defaults
///
/// ## vs Regular Options
///
/// Use [ChoiceOption] when:
/// - Input should be restricted to specific values
/// - You want a dropdown menu interface
/// - Validation is important (prevent invalid input)
/// - Options are known in advance
///
/// Use [Option] when:
/// - Free-form input is acceptable
/// - Input possibilities are unlimited or unknown
/// - Users need to provide custom values
///
/// See also:
/// - [Choice] for defining individual choices
/// - [Option] for regular command options without choices
/// - [CommandOption] for the option interface
final class ChoiceOption implements CommandOption {
  /// The option name (parameter name in the handler).
  @override
  final String name;

  /// The option description shown to users.
  @override
  final String description;

  /// The option type (string, integer, or double).
  @override
  final CommandOptionType type;

  /// Whether this option is required.
  @override
  final bool isRequired;

  /// Channel types filter (not used for choice options).
  @override
  final List<ChannelType>? channelTypes;

  /// The list of predefined choices users can select from.
  final List<Choice> choices;

  const ChoiceOption._(this.name, this.description, this.type, this.isRequired,
      this.channelTypes, this.choices);

  /// Converts this choice option to a JSON representation for the Discord API.
  ///
  /// Returns a map containing the option configuration including all choices.
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': isRequired,
      'choices':
          choices.map((e) => {'name': e.name, 'value': e.value}).toList(),
    };
  }

  /// Creates a string choice option with predefined text choices.
  ///
  /// Users will see a dropdown with the choice names and the handler will
  /// receive the selected choice's value as a [String].
  ///
  /// Example:
  /// ```dart
  /// ChoiceOption.string(
  ///   name: 'region',
  ///   description: 'Select your region',
  ///   required: true,
  ///   choices: [
  ///     Choice('North America', 'na'),
  ///     Choice('Europe', 'eu'),
  ///     Choice('Asia', 'asia'),
  ///   ],
  /// )
  /// ```
  ///
  /// Parameters:
  /// - [name]: The parameter name (used in handler)
  /// - [description]: Description shown to users
  /// - [choices]: List of available choices (max 25)
  /// - [required]: Whether this option is required (default: false)
  factory ChoiceOption.string(
          {required String name,
          required String description,
          required List<Choice<String>> choices,
          bool required = false}) =>
      ChoiceOption._(
          name, description, CommandOptionType.string, required, null, choices);

  /// Creates an integer choice option with predefined number choices.
  ///
  /// Users will see a dropdown with the choice names and the handler will
  /// receive the selected choice's value as an [int].
  ///
  /// Example:
  /// ```dart
  /// ChoiceOption.integer(
  ///   name: 'level',
  ///   description: 'Select level',
  ///   required: true,
  ///   choices: [
  ///     Choice('Beginner', 1),
  ///     Choice('Intermediate', 2),
  ///     Choice('Advanced', 3),
  ///   ],
  /// )
  /// ```
  ///
  /// Parameters:
  /// - [name]: The parameter name (used in handler)
  /// - [description]: Description shown to users
  /// - [choices]: List of available choices (max 25)
  /// - [required]: Whether this option is required (default: false)
  factory ChoiceOption.integer(
          {required String name,
          required String description,
          required List<Choice<int>> choices,
          bool required = false}) =>
      ChoiceOption._(name, description, CommandOptionType.integer, required,
          null, choices);

  /// Creates a double choice option with predefined decimal number choices.
  ///
  /// Users will see a dropdown with the choice names and the handler will
  /// receive the selected choice's value as a [double].
  ///
  /// Example:
  /// ```dart
  /// ChoiceOption.double(
  ///   name: 'tax_rate',
  ///   description: 'Select tax rate',
  ///   required: false,
  ///   choices: [
  ///     Choice('5%', 0.05),
  ///     Choice('10%', 0.10),
  ///     Choice('15%', 0.15),
  ///   ],
  /// )
  /// ```
  ///
  /// Parameters:
  /// - [name]: The parameter name (used in handler)
  /// - [description]: Description shown to users
  /// - [choices]: List of available choices (max 25)
  /// - [required]: Whether this option is required (default: false)
  factory ChoiceOption.double(
          {required String name,
          required String description,
          required List<Choice<double>> choices,
          bool required = false}) =>
      ChoiceOption._(
          name, description, CommandOptionType.double, required, null, choices);
}

/// Represents a single choice in a [ChoiceOption].
///
/// A choice consists of a display name (what users see) and a value (what your
/// handler receives). This separation allows for user-friendly display names
/// while using simple, consistent values in your code.
///
/// ## Type Parameter
///
/// - [T]: The value type ([String], [int], or [double])
///
/// ## Usage
///
/// ### String Choices
/// ```dart
/// Choice('Red Color', 'red'),        // User sees "Red Color", handler gets "red"
/// Choice('Blue Color', 'blue'),      // User sees "Blue Color", handler gets "blue"
/// ```
///
/// ### Integer Choices
/// ```dart
/// Choice('Small (10)', 10),          // User sees "Small (10)", handler gets 10
/// Choice('Large (50)', 50),          // User sees "Large (50)", handler gets 50
/// ```
///
/// ### Double Choices
/// ```dart
/// Choice('Half Speed', 0.5),         // User sees "Half Speed", handler gets 0.5
/// Choice('Double Speed', 2.0),       // User sees "Double Speed", handler gets 2.0
/// ```
///
/// ### With Emojis
/// ```dart
/// Choice('🔴 Critical', 1),
/// Choice('🟡 Warning', 2),
/// Choice('🟢 Info', 3),
/// ```
///
/// ## Best Practices
///
/// - **Descriptive names**: Make names clear and self-explanatory
/// - **Short and sweet**: Keep names concise (1-100 characters)
/// - **Consistent values**: Use a consistent format for values
/// - **Visual indicators**: Use emojis to make choices more intuitive
/// - **Unique values**: Ensure each choice has a unique value
///
/// See also:
/// - [ChoiceOption] for creating options with choices
final class Choice<T> {
  /// The display name shown to users in Discord's interface.
  ///
  /// Can include emojis, spaces, and special characters. Must be 1-100 characters.
  final String name;
  
  /// The value sent to your handler when this choice is selected.
  ///
  /// Should be a simple, consistent identifier. For strings, must be 1-100 characters.
  final T value;

  /// Creates a new choice with the given name and value.
  ///
  /// Example:
  /// ```dart
  /// const choice = Choice('Premium Plan', 'premium');
  /// ```
  const Choice(this.name, this.value);
}
