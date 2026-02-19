import 'package:mineral/src/domains/commands/command_builder.dart';

/// Base contract for command declarations.
///
/// The [CommandContract] defines the interface for command classes that use
/// builders to construct their command structure. This enables a class-based
/// approach to command organization where each command is a separate class.
///
/// ## Type Parameter
///
/// - [T]: The builder type that extends [CommandBuilder]
///
/// ## Usage
///
/// This is an interface contract implemented by:
/// - [CommandDeclaration] for programmatic commands with localization
/// - [CommandDefinition] for file-based command definitions
///
/// ### Example with CommandDeclaration
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
/// ### Example with CommandDefinition
/// ```dart
/// final class AdminCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/admin.yaml'))
///       ..setHandler('admin.ban', banUser);
///   }
///   
///   void banUser(ServerCommandContext ctx, {required User target}) {
///     // Ban logic
///   }
/// }
/// ```
///
/// ## Registration
///
/// Commands implementing this contract are registered using:
/// ```dart
/// client.register(PingCommand.new);
/// ```
///
/// See also:
/// - [CommandDeclaration] for programmatic command declarations
/// - [CommandDefinition] for file-based command definitions
/// - [CommandBuilder] for the builder interface
abstract interface class CommandContract<T extends CommandBuilder> {
  /// Builds and returns the command builder with full configuration.
  ///
  /// This method is called by the framework when registering the command.
  /// It should return a fully configured builder with name, description,
  /// options, handlers, and any other necessary configuration.
  T build();
}
