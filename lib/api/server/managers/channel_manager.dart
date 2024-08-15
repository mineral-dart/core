import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';

enum _ServerNamedChannel {
  afkChannel,
  systemChannel,
  rulesChannel,
  publicUpdatesChannel,
  safetyAlertsChannel,
  widgetChannel,
}

final class ChannelManager {
  final Map<_ServerNamedChannel, Snowflake?> _namedChannels = {};
  final Map<Snowflake, ServerChannel> _channels;
  final Map<Snowflake, ThreadChannel> threads = {}; // todo

  ChannelManager(this._channels, Map<String, dynamic> json) {
    _namedChannels
      ..putIfAbsent(_ServerNamedChannel.afkChannel, () => json['afk_channel_id'])
      ..putIfAbsent(_ServerNamedChannel.systemChannel, () => json['system_channel_id'])
      ..putIfAbsent(_ServerNamedChannel.rulesChannel, () => json['rules_channel_id'])
      ..putIfAbsent(
          _ServerNamedChannel.publicUpdatesChannel, () => json['public_updates_channel_id'])
      ..putIfAbsent(
          _ServerNamedChannel.safetyAlertsChannel, () => json['safety_alerts_channel_id']);
  }

  Map<Snowflake, ServerChannel> get list => _channels;

  T? getOrNull<T extends ServerChannel>(Snowflake? id) => _channels[id] as T?;

  T getOrFail<T extends ServerChannel>(String id) =>
      _channels.values.firstWhere((element) => element.id.value == id,
          orElse: () => throw Exception('Channel not found')) as T;

  ServerVoiceChannel? get afkChannel =>
      getOrNull<ServerVoiceChannel>(_namedChannels[_ServerNamedChannel.afkChannel]);

  ServerTextChannel? get systemChannel =>
      getOrNull<ServerTextChannel>(_namedChannels[_ServerNamedChannel.systemChannel]);

  ServerTextChannel? get rulesChannel =>
      getOrNull<ServerTextChannel>(_namedChannels[_ServerNamedChannel.rulesChannel]);

  ServerTextChannel? get publicUpdatesChannel =>
      getOrNull<ServerTextChannel>(_namedChannels[_ServerNamedChannel.publicUpdatesChannel]);

  ServerTextChannel? get safetyAlertsChannel =>
      getOrNull<ServerTextChannel>(_namedChannels[_ServerNamedChannel.safetyAlertsChannel]);

  ServerTextChannel? get widgetChannel =>
      getOrNull<ServerTextChannel>(_namedChannels[_ServerNamedChannel.widgetChannel]);

  factory ChannelManager.fromList(List<ServerChannel> channels, payload) {
    return ChannelManager(
        Map<Snowflake, ServerChannel>.from(channels.fold({}, (value, element) {
          return {...value, element.id: element};
        })),
        payload);
  }
}
