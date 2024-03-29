import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/channel_properties.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/data_store/data_store.dart';

final class ServerTextChannel extends ServerChannel {
  final ChannelProperties _properties;

  @override
  Snowflake get id => _properties.id;

  @override
  ChannelType get type => _properties.type;

  @override
  String get name => _properties.name!;

  @override
  int get position => _properties.position!;

  @override
  List<ChannelPermissionOverwrite> get permissions => _properties.permissions!;

  String? get description => _properties.description;

  late final ServerCategoryChannel? category;

  ServerTextChannel(this._properties);

  Future<void> setName(String name, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'name': name},
    );
  }

  Future<void> setDescription(String description, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'topic': description},
    );
  }

  Future<void> setCategory(String categoryId, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'parent_id': categoryId},
    );
  }

  Future<void> setPosition(int position, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'position': position},
    );
  }

  Future<void> setNsfw(bool nsfw, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'nsfw': nsfw},
    );
  }

  Future<void> setRateLimitPerUser(int rateLimitPerUser, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'rate_limit_per_user': rateLimitPerUser},
    );
  }

  Future<void> setDefaultAutoArchiveDuration(int defaultAutoArchiveDuration, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'default_auto_archive_duration': defaultAutoArchiveDuration},
    );
  }

  Future<void> setDefaultThreadRateLimitPerUser(int value, {String? reason}) async {
    await DataStore.singleton().channel.updateChannel(
      id: id,
      reason: reason,
      payload: {'default_thread_rate_limit_per_user': value},
    );
  }

  Future<void> delete({String? reason}) async {
    await DataStore.singleton().channel.deleteChannel(id, reason);
  }
}
