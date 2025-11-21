import 'package:mineral/src/api/common/commands/command_option_type.dart';
import 'package:mineral/src/api/common/types/channel_type.dart';

/// Base interface for command options.
///
/// The [CommandOption] interface defines the contract for all command option
/// types, including [Option] for standard options and [ChoiceOption] for
/// options with predefined choices.
///
/// This interface ensures consistent structure across different option types
/// and enables serialization to Discord's API format.
///
/// See also:
/// - [Option] for standard command options
/// - [ChoiceOption] for options with predefined choices
abstract interface class CommandOption {
  /// For channel options, restricts which channel types are selectable.
  ///
  /// Only applies when [type] is [CommandOptionType.channel].
  List<ChannelType>? get channelTypes;

  /// The user-visible description of this option.
  ///
  /// Explains the purpose and expected value to users.
  String get description;

  /// Whether this option must be provided by the user.
  ///
  /// Required options must appear before optional ones.
  bool get isRequired;

  /// The unique name of this option.
  ///
  /// Must be lowercase, alphanumeric with hyphens, and unique within the command.
  String get name;

  /// The data type of this option's value.
  ///
  /// Determines what kind of input Discord accepts (string, integer, user, etc.).
  CommandOptionType get type;

  /// Converts this option to Discord API JSON format.
  Map<String, dynamic> toJson();
}

/// Standard command option for accepting user input of various types.
///
/// The [Option] class provides factory methods for creating type-specific
/// command options. Each factory method creates an option configured for
/// a specific Discord data type (string, integer, user, role, etc.).
///
/// ## Supported Types
///
/// - **Text**: [string] for text input
/// - **Numbers**: [integer] for whole numbers, [double] for decimals
/// - **Boolean**: [boolean] for true/false choices
/// - **Discord Entities**: [user], [channel], [role], [mentionable]
/// - **Files**: [attachment] for file uploads
///
/// ## Usage
///
/// ### String Option
/// ```dart
/// final command = CommandBuilder()
///   ..setName('echo')
///   ..setDescription('Repeat a message')
///   ..addOption(Option.string(
///     name: 'message',
///     description: 'Message to repeat',
///     required: true,
///   ))
///   ..handle((CommandContext ctx, {required String message}) {
///     ctx.interaction.reply(
///       builder: MessageBuilder.text(message),
///     );
///   });
/// ```
///
/// ### Integer Option
/// ```dart
/// final command = CommandBuilder()
///   ..setName('repeat')
///   ..setDescription('Repeat a message multiple times')
///   ..addOption(Option.string(
///     name: 'message',
///     description: 'Message to repeat',
///     required: true,
///   ))
///   ..addOption(Option.integer(
///     name: 'count',
///     description: 'Number of repetitions (1-10)',
///     required: false,
///   ))
///   ..handle((CommandContext ctx, {required String message, int? count}) {
///     final times = count ?? 1;
///     ctx.interaction.reply(
///       builder: MessageBuilder.text(message * times),
///     );
///   });
/// ```
///
/// ### User Option
/// ```dart
/// final command = CommandBuilder()
///   ..setName('profile')
///   ..setDescription('View user profile')
///   ..addOption(Option.user(
///     name: 'target',
///     description: 'User to view',
///     required: false,
///   ))
///   ..handle((CommandContext ctx, {User? target}) {
///     final user = target ?? ctx.user;
///     // Display profile logic
///   });
/// ```
///
/// ### Channel Option with Type Restriction
/// ```dart
/// final command = CommandBuilder()
///   ..setName('announce')
///   ..setDescription('Send announcement')
///   ..addOption(Option.channel(
///     name: 'target',
///     description: 'Channel for announcement',
///     channels: [ChannelType.guildText, ChannelType.guildNews],
///     required: true,
///   ))
///   ..handle((ServerCommandContext ctx, {required Channel target}) {
///     // Send announcement logic
///   });
/// ```
///
/// ### Multiple Options
/// ```dart
/// final command = CommandBuilder()
///   ..setName('warn')
///   ..setDescription('Warn a user')
///   ..addOption(Option.user(
///     name: 'target',
///     description: 'User to warn',
///     required: true,
///   ))
///   ..addOption(Option.string(
///     name: 'reason',
///     description: 'Warning reason',
///     required: true,
///   ))
///   ..addOption(Option.boolean(
///     name: 'silent',
///     description: 'Hide warning from user',
///     required: false,
///   ))
///   ..handle((ServerCommandContext ctx, {
///     required User target,
///     required String reason,
///     bool? silent,
///   }) {
///     // Warning logic
///   });
/// ```
///
/// ## Required vs Optional
///
/// - **Required options** (`required: true`):
///   - User must provide a value
///   - Must appear before optional options
///   - Handler parameter uses `required` keyword
///
/// - **Optional options** (`required: false`):
///   - User can omit the value
///   - Must appear after required options
///   - Handler parameter is nullable (`Type?`)
///
/// ## Best Practices
///
/// - **Clear names**: Use descriptive, lowercase names with hyphens
/// - **Helpful descriptions**: Explain what the option does and valid values
/// - **Required first**: Place all required options before optional ones
/// - **Channel restrictions**: Use `channels` parameter to limit channel types
/// - **Validation**: Validate option values in your handler
/// - **Defaults**: Provide sensible defaults for optional options
///
/// ## vs ChoiceOption
///
/// Use [Option] when:
/// - User provides free-form input
/// - No predefined set of valid values
/// - Need text, numbers, or Discord entities
///
/// Use [ChoiceOption] when:
/// - Limiting user to specific values
/// - Creating dropdown menus
/// - Preventing invalid input
///
/// See also:
/// - [ChoiceOption] for options with predefined choices
/// - [CommandOptionType] for available data types
/// - [ChannelType] for channel type restrictions
final class Option<T> implements CommandOption {
  @override
  final String name;

  @override
  final String description;

  @override
  final bool isRequired;

  @override
  final CommandOptionType type;

  @override
  final List<ChannelType>? channelTypes;

  /// Creates an attachment option for file uploads.
  ///
  /// Attachment options allow users to upload files.
  ///
  /// Example:
  /// ```dart
  /// Option.attachment(
  ///   name: 'file',
  ///   description: 'File to upload',
  ///   required: true,
  /// )
  /// ```
  factory Option.attachment(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.attachment, null, required);

  /// Creates a boolean option for true/false choices.
  ///
  /// Boolean options present a simple true/false choice to users.
  ///
  /// Example:
  /// ```dart
  /// Option.boolean(
  ///   name: 'ephemeral',
  ///   description: 'Make response visible only to you',
  ///   required: false,
  /// )
  /// ```
  factory Option.boolean(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.boolean, null, required);

  /// Creates a channel option for selecting server channels.
  ///
  /// Channel options allow selecting channels, optionally restricted to
  /// specific types via the [channels] parameter.
  ///
  /// Example:
  /// ```dart
  /// Option.channel(
  ///   name: 'target',
  ///   description: 'Channel to post in',
  ///   channels: [ChannelType.guildText],
  ///   required: true,
  /// )
  /// ```
  factory Option.channel(
          {required String name,
          required String description,
          List<ChannelType> channels = const [],
          bool required = false}) =>
      Option._(
          name, description, CommandOptionType.channel, channels, required);

  /// Creates a double option for accepting decimal numbers.
  ///
  /// Double options accept decimal numbers.
  ///
  /// Example:
  /// ```dart
  /// Option.double(
  ///   name: 'multiplier',
  ///   description: 'Multiplier value (0.1-10.0)',
  ///   required: false,
  /// )
  /// ```
  factory Option.double(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.double, null, required);

  /// Creates an integer option for accepting whole numbers.
  ///
  /// Integer options accept whole numbers (no decimals).
  ///
  /// Example:
  /// ```dart
  /// Option.integer(
  ///   name: 'count',
  ///   description: 'Number of items (1-100)',
  ///   required: false,
  /// )
  /// ```
  factory Option.integer(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.integer, null, required);

  /// Creates a mentionable option for selecting users or roles.
  ///
  /// Mentionable options accept either users or roles.
  ///
  /// Example:
  /// ```dart
  /// Option.mentionable(
  ///   name: 'target',
  ///   description: 'User or role to mention',
  ///   required: true,
  /// )
  /// ```
  factory Option.mentionable(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(
          name, description, CommandOptionType.mentionable, null, required);

  /// Creates a role option for selecting server roles.
  ///
  /// Role options allow selecting any role in the server.
  ///
  /// Example:
  /// ```dart
  /// Option.role(
  ///   name: 'role',
  ///   description: 'Role to assign',
  ///   required: true,
  /// )
  /// ```
  factory Option.role(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.role, null, required);

  /// Creates a string option for accepting text input.
  ///
  /// String options accept any text input from users.
  ///
  /// Example:
  /// ```dart
  /// Option.string(
  ///   name: 'message',
  ///   description: 'Your message',
  ///   required: true,
  /// )
  /// ```
  factory Option.string(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.string, null, required);

  /// Creates a user option for selecting server members.
  ///
  /// User options allow selecting any user visible to the bot.
  ///
  /// Example:
  /// ```dart
  /// Option.user(
  ///   name: 'target',
  ///   description: 'User to mention',
  ///   required: true,
  /// )
  /// ```
  factory Option.user(
          {required String name,
          required String description,
          bool required = false}) =>
      Option._(name, description, CommandOptionType.user, null, required);

  const Option._(this.name, this.description, this.type, this.channelTypes,
      this.isRequired);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type.value,
      'required': isRequired,
      'channel_types': channelTypes?.map((e) => e.value).toList(),
    };
  }
}
