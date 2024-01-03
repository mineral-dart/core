import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

enum _GuildNamedChannel {
  afkChannel,
  systemChannel,
  rulesChannel,
  publicUpdatesChannel,
  safetyAlertsChannel,
  widgetChannel,
}

final class GuildChannelCollection {
  final Map<_GuildNamedChannel, String?> _namedChannels;
  final Map<String, GuildChannel> _channels;

  GuildChannelCollection(this._channels, this._namedChannels);

  Map<String, GuildChannel> get list => _channels;

  T? getOrNull<T extends GuildChannel>(String? id) => _channels[id] as T?;

  GuildVoiceChannel? get afkChannel =>
      getOrNull<GuildVoiceChannel>(_namedChannels[_GuildNamedChannel.afkChannel]);

  GuildTextChannel? get systemChannel =>
      getOrNull<GuildTextChannel>(_namedChannels[_GuildNamedChannel.systemChannel]);

  GuildTextChannel? get rulesChannel =>
      getOrNull<GuildTextChannel>(_namedChannels[_GuildNamedChannel.rulesChannel]);

  GuildTextChannel? get publicUpdatesChannel =>
      getOrNull<GuildTextChannel>(_namedChannels[_GuildNamedChannel.publicUpdatesChannel]);

  GuildTextChannel? get safetyAlertsChannel =>
      getOrNull<GuildTextChannel>(_namedChannels[_GuildNamedChannel.safetyAlertsChannel]);

  GuildTextChannel? get widgetChannel =>
      getOrNull<GuildTextChannel>(_namedChannels[_GuildNamedChannel.widgetChannel]);

  factory GuildChannelCollection.fromJson(
      {required String guildId, required Map<String, dynamic> json}) {
    final channels = Map<String, GuildChannel>.from(json['channels'].fold({}, (value, element) {
      final channel = ChannelFactory.make(guildId, element);
      return channel != null ? {...value, channel.id: channel} : value;
    }));

    final Map<_GuildNamedChannel, String?> namedChannels = {
      _GuildNamedChannel.afkChannel: json['afk_channel_id'],
      _GuildNamedChannel.systemChannel: json['system_channel_id'],
      _GuildNamedChannel.rulesChannel: json['rules_channel_id'],
      _GuildNamedChannel.publicUpdatesChannel: json['public_updates_channel_id'],
      _GuildNamedChannel.safetyAlertsChannel: json['safety_alerts_channel_id'],
    };

    return GuildChannelCollection(channels, namedChannels);
  }
}
