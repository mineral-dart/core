import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

/// Represents the bot user account and provides access to bot-specific operations.
///
/// [Bot] contains all the information about the authenticated bot account,
/// including its identity, settings, and connected servers. It provides methods
/// for updating the bot's presence and status.
///
/// ## Accessing the Bot Instance
///
/// The bot instance is typically accessed through dependency injection:
///
/// ```dart
/// final bot = ioc.resolve<Bot>();
/// ```
///
/// ## Usage Examples
///
/// ### Update bot presence
///
/// ```dart
/// bot.setPresence(
///   activities: [BotActivity.playing('with ${servers.length} servers')],
///   status: StatusType.online,
/// );
/// ```
///
/// ### Get bot information
///
/// ```dart
/// print('Bot username: ${bot.username}');
/// print('Bot ID: ${bot.id}');
/// print('Connected to ${bot.guildIds.length} servers');
/// ```
///
/// See also:
/// - [BotActivity] for creating bot activities
/// - [StatusType] for available online statuses
final class Bot {
  /// The unique Discord snowflake ID of the bot.
  final Snowflake id;

  /// The bot's discriminator (the 4 digits after the #).
  ///
  /// Note: Discord is phasing out discriminators in favor of unique usernames.
  /// This may be null for bots migrated to the new username system.
  final String? discriminator;

  /// The Discord gateway protocol version being used.
  final int version;

  /// The bot's Discord username.
  ///
  /// This is the display name shown in Discord without the discriminator.
  final String username;

  /// Whether the bot account has two-factor authentication (MFA) enabled.
  ///
  /// It's recommended to enable MFA for bot accounts with elevated permissions.
  final bool hasEnabledMfa;

  /// The bot's global display name, if set.
  ///
  /// This is the name shown across Discord instead of the username,
  /// if the account has been migrated to Discord's new username system.
  final String? globalName;

  /// Bitfield of flags describing the bot account features.
  ///
  /// These flags indicate various account states and features enabled for the bot.
  final int flags;

  /// The hash of the bot's avatar image, if set.
  ///
  /// Can be used with Discord's CDN to retrieve the full avatar URL.
  /// Null if the bot has no custom avatar set.
  final String? avatar;

  /// The type of session for this connection.
  ///
  /// Typically indicates the gateway session type (e.g., "normal").
  final String sessionType;

  /// List of private channels (DMs) the bot has open.
  ///
  /// Contains direct message channels between the bot and individual users.
  final List privateChannels;

  /// List of presence information for the bot.
  ///
  /// Contains the bot's current activity and online status data.
  final List presences;

  /// List of snowflake IDs for all servers (guilds) the bot is connected to.
  ///
  /// Use these IDs to retrieve full [Server] objects from the cache or API.
  final List<String> guildIds;

  /// Partial information about the bot's application.
  ///
  /// Contains the application ID and flags for the bot's Discord application.
  final PartialApplication application;

  /// Creates a [Bot] instance from Discord gateway JSON data.
  ///
  /// This factory constructor is used internally when the bot connects to
  /// Discord's gateway and receives the READY event with bot information.
  ///
  /// The [json] parameter should contain the full READY payload from Discord.
  factory Bot.fromJson(Map<String, dynamic> json) => Bot._(
        id: Snowflake.parse(json['user']['id']),
        discriminator: json['user']['discriminator'],
        version: json['v'],
        username: json['user']['username'],
        hasEnabledMfa: json['user']['mfa_enabled'],
        globalName: json['user']['global_name'],
        flags: json['user']['flags'],
        avatar: json['user']['avatar'],
        sessionType: json['session_type'],
        privateChannels: json['private_channels'],
        presences: json['presences'],
        guildIds: List<String>.from(
          json['guilds'].map((element) => Snowflake.parse(element['id'])),
        ),
        application: PartialApplication(
          id: Snowflake.parse(json['application']['id']),
          flags: json['application']['flags'],
        ),
      );

  /// Creates a new [Bot] instance with the specified properties.
  ///
  /// This constructor is private and only used internally by [Bot.fromJson].
  /// The bot instance is automatically registered in the IoC container.
  Bot._({
    required this.id,
    required this.discriminator,
    required this.version,
    required this.username,
    required this.hasEnabledMfa,
    required this.globalName,
    required this.flags,
    required this.avatar,
    required this.sessionType,
    required this.privateChannels,
    required this.presences,
    required this.guildIds,
    required this.application,
  }) {
    ioc.bind<Bot>(() => this);
  }

  WebsocketOrchestratorContract get _wss =>
      ioc.resolve<WebsocketOrchestratorContract>();

  /// Updates the bot's presence (activity and online status).
  ///
  /// This method allows you to change what activity the bot is displaying
  /// (e.g., "Playing Minecraft") and its online status (online, idle, dnd, invisible).
  ///
  /// All parameters are optional:
  /// - [activities]: List of activities to display (Discord shows the first one)
  /// - [status]: The bot's online status (online, idle, dnd, invisible)
  /// - [afk]: Whether the bot should be marked as AFK
  ///
  /// Example:
  /// ```dart
  /// // Set a simple playing activity
  /// bot.setPresence(
  ///   activities: [BotActivity.playing('Minecraft')],
  ///   status: StatusType.online,
  /// );
  ///
  /// // Set multiple activities (Discord will display the first)
  /// bot.setPresence(
  ///   activities: [
  ///     BotActivity.playing('with commands'),
  ///     BotActivity.listening('music'),
  ///   ],
  ///   status: StatusType.idle,
  /// );
  ///
  /// // Set streaming activity with live indicator
  /// bot.setPresence(
  ///   activities: [
  ///     BotActivity.streaming('Live Development', 'https://twitch.tv/username'),
  ///   ],
  ///   status: StatusType.online,
  /// );
  ///
  /// // Mark as Do Not Disturb with no activity
  /// bot.setPresence(status: StatusType.dnd);
  /// ```
  ///
  /// See also:
  /// - [BotActivity] for creating activities
  /// - [StatusType] for available statuses
  void setPresence({
    List<BotActivity>? activities,
    StatusType? status,
    bool? afk,
  }) =>
      _wss.setBotPresence(activities, status, afk);

  /// Returns a Discord mention string for the bot.
  ///
  /// This produces a string like "<@123456789>" that will mention the bot
  /// when sent in a Discord message.
  @override
  String toString() => '<@$id>';
}
