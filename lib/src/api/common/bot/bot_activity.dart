import 'package:mineral/api.dart';

/// Represents an activity that can be displayed on a bot's Discord presence.
///
/// [BotActivity] allows customization of what the bot displays as its current
/// activity in Discord, including gaming, streaming, listening, or watching activities.
/// This is visible to users in the member list and user profile.
///
/// ## Usage
///
/// Create activities using the factory constructors for common activity types:
///
/// ```dart
/// // Show the bot as playing a game
/// final playing = BotActivity.playing('Minecraft');
///
/// // Show the bot as streaming
/// final streaming = BotActivity.streaming('Live Coding', 'https://twitch.tv/username');
///
/// // Show the bot as listening to music
/// final listening = BotActivity.listening('Spotify');
///
/// // Show the bot as watching something
/// final watching = BotActivity.watching('YouTube');
/// ```
///
/// ## Setting Bot Presence
///
/// Use with [Bot] to set the bot's presence:
///
/// ```dart
/// await bot.updatePresence(
///   activity: BotActivity.playing('with ${servers.length} servers'),
///   status: StatusType.online,
/// );
/// ```
///
/// ## Activity Types
///
/// - **Playing**: Shows "Playing {name}" (e.g., "Playing Minecraft")
/// - **Streaming**: Shows "Streaming {name}" with a purple "LIVE" indicator
/// - **Listening**: Shows "Listening to {name}" (e.g., "Listening to Spotify")
/// - **Watching**: Shows "Watching {name}" (e.g., "Watching YouTube")
///
/// See also:
/// - [GamePresence] for the available activity types
/// - [StatusType] for setting the bot's online status
class BotActivity {
  /// The name of the activity displayed to users.
  ///
  /// This is the main text shown in the activity status. For example,
  /// "Minecraft" in "Playing Minecraft" or "Spotify" in "Listening to Spotify".
  String? name;

  /// The type of activity being displayed.
  ///
  /// Determines how Discord formats and displays the activity.
  /// See [GamePresence] for available types.
  GamePresence type;

  /// The URL for streaming activities.
  ///
  /// Only used when [type] is [GamePresence.streaming]. Must be a valid
  /// Twitch or YouTube URL. If provided with other activity types, it will
  /// be ignored by Discord.
  ///
  /// Example: `https://twitch.tv/username`
  String? url;

  /// Custom emoji to display with the activity.
  ///
  /// Allows adding a custom or standard emoji to the activity status.
  /// Only works with custom activities.
  PartialEmoji? emoji;

  /// Custom status text for custom activities.
  ///
  /// Used for custom activity types to provide additional context or
  /// description text.
  /// Custom status text for custom activities.
  ///
  /// Used for custom activity types to provide additional context or
  /// description text.
  String? state;

  /// Creates a bot activity with the specified type and optional details.
  ///
  /// Example:
  /// ```dart
  /// final activity = BotActivity(
  ///   type: GamePresence.game,
  ///   name: 'Minecraft',
  /// );
  /// ```
  BotActivity({required this.type, this.name, this.url, this.emoji, this.state});

  /// Creates a "Listening" activity.
  ///
  /// Displays as "Listening to {name}" in Discord (e.g., "Listening to Spotify").
  ///
  /// Example:
  /// ```dart
  /// final activity = BotActivity.listening('Spotify');
  /// await bot.updatePresence(activity: activity);
  /// ```
  factory BotActivity.listening(String name) {
    return BotActivity(name: name, type: GamePresence.listening);
  }

  /// Creates a "Playing" activity.
  ///
  /// Displays as "Playing {name}" in Discord (e.g., "Playing Minecraft").
  ///
  /// Example:
  /// ```dart
  /// final activity = BotActivity.playing('Minecraft');
  /// await bot.updatePresence(activity: activity);
  /// ```
  factory BotActivity.playing(String name) {
    return BotActivity(name: name, type: GamePresence.game);
  }

  /// Creates a "Streaming" activity with a live indicator.
  ///
  /// Displays as "Streaming {name}" with a purple "LIVE" badge in Discord.
  /// The [url] must be a valid Twitch or YouTube streaming URL.
  ///
  /// Example:
  /// ```dart
  /// final activity = BotActivity.streaming(
  ///   'Live Coding Session',
  ///   'https://twitch.tv/myusername',
  /// );
  /// await bot.updatePresence(activity: activity);
  /// ```
  ///
  /// Note: Only Twitch and YouTube URLs are supported by Discord for streaming activities.
  factory BotActivity.streaming(String name, String url) {
    return BotActivity(name: name, type: GamePresence.streaming, url: url);
  }

  /// Creates a "Watching" activity.
  ///
  /// Displays as "Watching {name}" in Discord (e.g., "Watching YouTube").
  ///
  /// Example:
  /// ```dart
  /// final activity = BotActivity.watching('YouTube');
  /// await bot.updatePresence(activity: activity);
  /// ```
  factory BotActivity.watching(String name) {
    return BotActivity(name: name, type: GamePresence.watching);
  }

  /// Converts this activity to a JSON representation for Discord's API.
  ///
  /// This method is used internally when sending presence updates to Discord.
  Object toJson() {
    return {
      'name': name,
      'type': type.value,
      if (url != null) 'url': url,
      if (state != null) 'state': state,
    };
  }
}
