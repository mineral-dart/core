import 'package:mineral/api/server/channels/guild_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class GuildChannelCollection {
  final Map<String, GuildChannel> _channels;

  GuildChannelCollection(this._channels);

  Map<String, GuildChannel> get list => _channels;

  T? getOrNull<T extends GuildChannel>(String? id) => _channels[id] as T?;

  factory GuildChannelCollection.fromJson({required String guildId, required List<dynamic> json}) {
    final channels = Map<String, GuildChannel>.from(json.fold({}, (value, element) {
      final channel = ChannelFactory.make(guildId, element);
      return channel != null ? {...value, channel.id: channel} : value;
    }));

    return GuildChannelCollection(channels);
  }
}
