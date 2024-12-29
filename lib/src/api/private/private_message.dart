import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/api/common/message_properties.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/private/channels/private_channel.dart';
import 'package:mineral/src/api/private/user.dart';

// final class PrivateMessage extends Message<PrivateChannel> {
//   DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();
//   final MessageProperties<PrivateChannel> _properties;
//
//   @override
//   Snowflake get id => _properties.id;
//
//   @override
//   String get content => _properties.content;
//
//   @override
//   List<MessageEmbed> get embeds => _properties.embeds;
//
//   @override
//   Snowflake get channelId => _properties.channelId;
//
//   @override
//   DateTime get createdAt => _properties.createdAt;
//
//   @override
//   DateTime? get updatedAt => _properties.updatedAt;
//
//   PrivateMessage(this._properties) : super(_properties);
//
//   @override
//   Future<User> resolveAuthor({bool force = false}) async {
//     final author = await _datastore.user.get(authorId!.value, force);
//     return author!;
//   }
//
//   @override
//   Future<PrivateChannel> resolveChannel() async {
//     final channel = await _datastore.channel.get<PrivateChannel>(channelId.value, false);
//     return channel!;
//   }
// }
