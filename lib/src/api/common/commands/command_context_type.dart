/// Defines where a Discord slash command can be used.
///
/// The [CommandContextType] determines the availability of a command across
/// different Discord contexts, affecting which [CommandContext] type is provided
/// to handlers and what Discord features are accessible.
///
/// ## Context Types
///
/// - [server]: Command available only in server (guild) channels
///   - Provides [ServerCommandContext] with guild-specific features
///   - Access to guild, roles, channels, members
///   - Default context type for most commands
///
/// - [global]: Command available everywhere (servers and DMs)
///   - Provides [GlobalCommandContext] without guild features
///   - Works in DMs, group DMs, and servers
///   - Limited to user and bot information
///
/// ## Usage
///
/// ### Server-Only Command (Default)
/// ```dart
/// final command = CommandBuilder()
///   ..setName('ban')
///   ..setDescription('Ban a user')
///   ..setContext(CommandContextType.server)
///   ..handle((ServerCommandContext ctx, {required User target}) {
///     final guild = ctx.guild;
///     // Server-specific features available
///   });
/// ```
///
/// ### Global Command (Servers and DMs)
/// ```dart
/// final command = CommandBuilder()
///   ..setName('ping')
///   ..setDescription('Check bot latency')
///   ..setContext(CommandContextType.global)
///   ..handle((GlobalCommandContext ctx) {
///     // Works anywhere, no guild features
///   });
/// ```
///
/// ## Choosing the Right Context
///
/// Use [server] when:
/// - Command needs guild information (roles, channels, members)
/// - Command performs server management actions
/// - Command requires server permissions
/// - Most moderation and management commands
///
/// Use [global] when:
/// - Command works independently of guilds
/// - Command provides user-specific information
/// - Command should be available in DMs
/// - Utility commands like ping, help, info
///
/// See also:
/// - [CommandContext] for the base context interface
/// - [ServerCommandContext] for server-specific context
/// - [GlobalCommandContext] for global context
enum CommandContextType {
  /// Command available only in server (guild) channels.
  ///
  /// Provides [ServerCommandContext] with access to guild features.
  server(0),

  /// Command available everywhere (servers and DMs).
  ///
  /// Provides [GlobalCommandContext] without guild-specific features.
  global(1);

  final int value;
  const CommandContextType(this.value);
}
