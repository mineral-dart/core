import 'package:mineral/src/api/common/commands/builder/command_definition_builder.dart';
import 'package:mineral/src/api/common/commands/command_contract.dart';
import 'package:mineral/src/domains/common/utils/listenable.dart';

/// Contract for file-based command definitions.
///
/// The [CommandDefinition] interface enables a class-based approach to defining
/// commands from external YAML or JSON configuration files, separating command
/// structure from handler logic. This is ideal for managing complex command
/// hierarchies and translations.
///
/// ## Usage
///
/// ### Basic Command
/// ```dart
/// final class PingCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/ping.yaml'))
///       ..setHandler('ping', handle);
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
/// ### Command with Multiple Handlers
/// ```dart
/// final class AdminCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/admin.yaml'))
///       ..setHandler('admin.user.ban', banUser)
///       ..setHandler('admin.user.kick', kickUser)
///       ..setHandler('admin.role.create', createRole);
///   }
///   
///   void banUser(ServerCommandContext ctx, {required User target}) {
///     // Ban logic
///   }
///   
///   void kickUser(ServerCommandContext ctx, {required User target}) {
///     // Kick logic
///   }
///   
///   void createRole(ServerCommandContext ctx) {
///     // Create role logic
///   }
/// }
/// ```
///
/// ## Configuration File
///
/// **admin.yaml**:
/// ```yaml
/// groups:
///   user:
///     name:
///       _default: user
///     description:
///       _default: User management
///
/// commands:
///   admin:
///     name:
///       _default: admin
///     description:
///       _default: Administrative commands
///   
///   admin.user.ban:
///     group: user
///     name:
///       _default: ban
///     description:
///       _default: Ban a user
///     options:
///       - name:
///           _default: target
///         description:
///           _default: User to ban
///         type: user
///         required: true
/// ```
///
/// ## Registration
///
/// ```dart
/// client.register(AdminCommand.new);
/// ```
///
/// ## vs CommandDeclaration
///
/// Use [CommandDefinition] when:
/// - Loading command structure from files
/// - Separating structure from logic
/// - Managing many commands with translations
/// - Prefer configuration-based approach
///
/// Use [CommandDeclaration] when:
/// - Building commands programmatically in code
/// - Need full type safety and IDE support
/// - Want to use modular subcommands
/// - Prefer code-based configuration
///
/// See also:
/// - [CommandDefinitionBuilder] for building commands from files
/// - [CommandDeclaration] for programmatic commands
/// - [PlaceholderContract] for dynamic configuration
abstract interface class CommandDefinition
    implements CommandContract<CommandDefinitionBuilder>, Listenable {
  @override
  CommandDefinitionBuilder build();
}
