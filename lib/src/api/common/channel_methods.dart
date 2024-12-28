import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/components/message_component.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/polls/poll.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/video_quality.dart';

final class ChannelMethods {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();
  final Snowflake? _serverId;

  final Snowflake id;

  ChannelMethods(this._serverId, this.id);

  Future<void> setName(String name, String? reason) async {
    final builder = ChannelBuilder(null)..setName(name);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setDescription(String value, String? reason) async {
    final builder = ChannelBuilder(null)..setTopic(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setCategory(String value, String? reason) async {
    final builder = ChannelBuilder(null)..setParentId(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setPosition(int value, String? reason) async {
    final builder = ChannelBuilder(null)..setPosition(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setNsfw(bool value, String? reason) async {
    final builder = ChannelBuilder(null)..setNsfw(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setRateLimitPerUser(Duration value, String? reason) async {
    final builder = ChannelBuilder(null)..setRateLimitPerUser(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setDefaultAutoArchiveDuration(Duration value, String? reason) async {
    final builder = ChannelBuilder(null)..setDefaultAutoArchiveDuration(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setDefaultThreadRateLimitPerUser(Duration value, String? reason) async {
    final builder = ChannelBuilder(null)..setDefaultThreadRateLimitPerUser(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setBitrate(int value, String? reason) async {
    final builder = ChannelBuilder(null)..setBitrate(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setUserLimit(int value, String? reason) async {
    final builder = ChannelBuilder(null)..setUserLimit(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setRtcRegion(String value, String? reason) async {
    final builder = ChannelBuilder(null)..setRtcRegion(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> setVideoQuality(VideoQuality value, String? reason) async {
    final builder = ChannelBuilder(null)..setVideoQualityMode(value);
    await _datastore.channel.update(
      id,
      builder,
      serverId: _serverId?.value,
      reason: reason,
    );
  }

  Future<void> send(
      {Snowflake? guildId,
      String? content,
      List<MessageEmbed>? embeds,
      Poll? poll,
      List<MessageComponent>? components}) async {
    await _datastore.channel.createMessage(guildId, id, content, embeds, poll, components);
  }

  Future<void> delete(String? reason) async {
    await _datastore.channel.deleteChannel(id, reason);
  }
}
