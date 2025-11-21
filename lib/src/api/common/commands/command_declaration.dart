import 'package:mineral/src/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/src/api/common/commands/command_contract.dart';
import 'package:mineral/src/domains/common/utils/listenable.dart';

/// Contract for programmatic command declarations with localization support.
///
/// The [CommandDeclaration] interface enables a class-based approach to defining
/// commands programmatically, with full support for translations, modular subcommands
/// via [SubCommandDeclaration], and type-safe option handling.
///
/// ## Usage
///
/// ### Basic Command
/// ```dart
/// final class PingCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('ping')
///       ..setDescription('Check bot latency')
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx) {
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Pong!'),
///     );
///   }
/// }
/// ```
///
/// ### Command with Localization
/// ```dart
/// final class GreetCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('greet', translation: Translation.from({
///         'en': 'greet',
///         'fr': 'saluer',
///       }))
///       ..setDescription('Greet someone', translation: Translation.from({
///         'en': 'Greet someone',
///         'fr': 'Saluer quelqu\'un',
///       }))
///       ..addOption(Option.user(
///         name: 'target',
///         description: 'User to greet',
///         required: true,
///       ))
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx, {required User target}) {
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Hello, ${target.username}!'),
///     );
///   }
/// }
/// ```
///
/// ### Command with Modular Subcommands
/// ```dart
/// final class TodoCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('todo')
///       ..setDescription('Manage tasks')
///       ..registerSubCommand(AddTaskSubCommand.new)
///       ..registerSubCommand(ListTasksSubCommand.new);
///   }
/// }
/// ```
///
/// ## Registration
///
/// ```dart
/// client.register(PingCommand.new);
/// ```
///
/// ## vs CommandDefinition
///
/// Use [CommandDeclaration] when:
/// - Building commands programmatically in code
/// - Need full type safety and IDE support
/// - Want to use modular subcommands
/// - Prefer code-based configuration
///
/// Use [CommandDefinition] when:
/// - Loading command structure from files
/// - Separating structure from logic
/// - Managing many commands with translations
/// - Prefer configuration-based approach
///
/// See also:
/// - [CommandDeclarationBuilder] for building commands
/// - [CommandDefinition] for file-based commands
/// - [SubCommandDeclaration] for modular subcommands
/// - [Translation] for localization
abstract interface class CommandDeclaration
    implements CommandContract<CommandDeclarationBuilder>, Listenable {
  @override
  CommandDeclarationBuilder build();
}
