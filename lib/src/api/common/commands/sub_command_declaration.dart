import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/domains/common/utils/listenable.dart';

/// Contract for modular, reusable subcommand declarations.
///
/// The [SubCommandDeclaration] interface enables you to define subcommands as
/// separate, self-contained classes that can be reused across multiple parent
/// commands. This promotes better code organization and reusability.
///
/// ## Benefits
///
/// - **Modularity**: Each subcommand is a separate class
/// - **Reusability**: Share subcommands across multiple parent commands
/// - **Maintainability**: Changes are isolated to subcommand classes
/// - **Simplified naming**: No need for unique handler names in large commands
/// - **Improved readability**: Main command stays clean and focused
///
/// ## Usage
///
/// ### Basic Subcommand
/// ```dart
/// final class AddSubCommand implements SubCommandDeclaration {
///   @override
///   SubCommandBuilder build() {
///     return SubCommandBuilder()
///       ..setName('add')
///       ..setDescription('Add a new item')
///       ..addOption(Option.string(
///         name: 'item',
///         description: 'Item to add',
///         required: true,
///       ))
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx, {required String item}) {
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Added: $item'),
///     );
///   }
/// }
/// ```
///
/// ### Subcommand with Multiple Options
/// ```dart
/// final class SearchSubCommand implements SubCommandDeclaration {
///   @override
///   SubCommandBuilder build() {
///     return SubCommandBuilder()
///       ..setName('search')
///       ..setDescription('Search for items')
///       ..addOption(Option.string(
///         name: 'query',
///         description: 'Search query',
///         required: true,
///       ))
///       ..addOption(ChoiceOption.string(
///         name: 'category',
///         description: 'Category to search in',
///         required: false,
///         choices: [
///           Choice('All', 'all'),
///           Choice('Active', 'active'),
///           Choice('Archived', 'archived'),
///         ],
///       ))
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx, {required String query, String? category}) {
///     final cat = category ?? 'all';
///     // Search logic
///   }
/// }
/// ```
///
/// ### Using in Parent Command
/// ```dart
/// final class ManageCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('manage')
///       ..setDescription('Manage items')
///       ..registerSubCommand(AddSubCommand.new)
///       ..registerSubCommand(SearchSubCommand.new)
///       ..registerSubCommand(RemoveSubCommand.new);
///   }
/// }
/// ```
///
/// ### Reusing Subcommands
/// ```dart
/// // Same subcommand used in multiple parent commands
/// final class AdminCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('admin')
///       ..setDescription('Admin commands')
///       ..registerSubCommand(ListSubCommand.new);  // Reused
///   }
/// }
///
/// final class UserCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('user')
///       ..setDescription('User commands')
///       ..registerSubCommand(ListSubCommand.new);  // Reused
///   }
/// }
/// ```
///
/// ## Best Practices
///
/// - **One class per subcommand**: Keep subcommands focused and independent
/// - **Clear naming**: Use descriptive class names (e.g., `AddTaskSubCommand`)
/// - **Self-contained**: Include all logic within the subcommand class
/// - **Reusable**: Design subcommands to work in multiple contexts
/// - **Documented**: Document what each subcommand does
///
/// See also:
/// - [SubCommandBuilder] for building subcommands
/// - [CommandDeclaration] for parent command declarations
/// - [CommandDeclarationBuilder.registerSubCommand] for registration
abstract interface class SubCommandDeclaration implements Listenable {
  /// Builds and returns the subcommand builder with full configuration.
  ///
  /// This method should return a fully configured [SubCommandBuilder] with
  /// name, description, options, and handler.
  SubCommandBuilder build();
}
