import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/channels/server_text_channel.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

enum _ServerNamedChannel {
  afkChannel,
  systemChannel,
  rulesChannel,
  publicUpdatesChannel,
  safetyAlertsChannel,
  widgetChannel,
}

final class ChannelManager {
  final Map<_ServerNamedChannel, String?> _namedChannels;
  final Map<String, ServerChannel> _channels;

  ChannelManager(this._channels, this._namedChannels);

  Map<String, ServerChannel> get list => _channels;

  T? getOrNull<T extends ServerChannel>(String? id) => _channels[id] as T?;

  T getOrFail<T extends ServerChannel>(String id) =>
      _channels.values.firstWhere((element) => element.id == id,
          orElse: () => throw Exception('Channel not found'))
      as T;

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

  factory ChannelManager.fromJson(
      {required MarshallerContract marshaller, required String guildId, required Map<String,
          dynamic> json}) {

    final categories = Map<String, ServerChannel>.from(
      List.from(json['channels'])
        .where((element) => element['type'] == ChannelType.guildCategory.value)
        .fold({}, (value, element) {
          final channel = marshaller.serializers.channels.serialize(element);
          return channel != null ? {...value, channel.id: channel} : value;
        })
    );

    marshaller.storage.channels.addAll(categories);

    final channels = Map<String, ServerChannel>.from(
      List.from(json['channels']).where((element) =>
      element['type'] != ChannelType.guildCategory.value).fold({}, (value, element) {
        final channel = marshaller.serializers.channels.serialize(element);
        return channel != null ? {...value, channel.id: channel} : value;
      })
    );

    final Map<_ServerNamedChannel, String?> namedChannels = {
      _ServerNamedChannel.afkChannel: json['afk_channel_id'],
      _ServerNamedChannel.systemChannel: json['system_channel_id'],
      _ServerNamedChannel.rulesChannel: json['rules_channel_id'],
      _ServerNamedChannel.publicUpdatesChannel: json['public_updates_channel_id'],
      _ServerNamedChannel.safetyAlertsChannel: json['safety_alerts_channel_id'],
    };

    return ChannelManager(channels, namedChannels);
  }
}
