

// final class ServerMessage extends Message<ServerChannel, Member> {
//   DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();
//   final MessageProperties<ServerChannel> _properties;
//
//   Snowflake get serverId => _properties.serverId!;
//
//   ServerMessage(this._properties) : super(_properties);
//
//   Future<Member> resolveAuthor({bool force = false}) async {
//     final author = await _datastore.member.get(serverId.value, authorId!.value, force);
//     return author!;
//   }
//
//   /// Reply to the original message.
//   ///
//   /// ```dart
//   /// await message.reply(content: 'Replying to the message');
//   /// ```
//   Future<void> reply(
//       {String? content, List<MessageEmbed>? embeds, List<MessageComponent>? components}) async {
//     final channel = await resolveChannel();
//     _datastore.serverMessage.reply(
//         id: id,
//         channelId: channelId,
//         serverId: channel.serverId,
//         content: content,
//         embeds: embeds,
//         components: components);
//   }
//
//   /// Pin the message.
//   ///
//   /// ```dart
//   /// await message.pin();
//   /// ```
//   Future<void> pin() async {
//     await _datastore.serverMessage.pin(id: id, channelId: channelId);
//   }
//
//   /// Unpin the message.
//   ///
//   /// ```dart
//   /// await message.unpin();
//   /// ```
//   Future<void> unpin() async {
//     await _datastore.serverMessage.unpin(id: id, channelId: channelId);
//   }
//
//   /// Crosspost the message.
//   ///
//   /// ```dart
//   /// await message.crosspost(); // only works for guild announcements
//   /// ```
//   Future<void> crosspost() async {
//     final channel = await resolveChannel();
//     if (channel.type != ChannelType.guildAnnouncement) {
//       return;
//     }
//
//     await _datastore.serverMessage.crosspost(id: id, channelId: channelId);
//   }
//
//   /// Delete the message.
//   ///
//   /// ```dart
//   /// await message.delete();
//   /// ```
//   Future<void> delete() async {
//     await _datastore.serverMessage.delete(id: id, channelId: channelId);
//   }
//
// // todo: addReaction, removeReaction, removeAllReactions, getReactions, clearReactions
// }
