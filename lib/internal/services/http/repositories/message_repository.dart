/// Repository for [Message] model.
/// Related [official documentation](https://discord.com/developers/docs/resources/channel#message-object)
final class MessageRepository {
  /// Get channel messages from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#get-channel-messages)
  /// ```dart
  /// final uri = http.endpoints.channels.getMessages('1150892323245408356');
  /// ```
  String all({ required String channelId }) => Uri(pathSegments: ['channels', channelId, 'messages']).path;

  /// Get channel message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#get-channel-message)
  /// ```dart
  /// final uri = http.endpoints.channels.one('1150892323245408356', '1150892323245408356');
  /// ```
  String one({ required String channelId, required String messageId }) => Uri(pathSegments: ['channels', channelId, 'messages', messageId]).path;

  /// Create channel message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#create-message)
  /// ```dart
  /// final uri = http.endpoints.channels.create('1150892323245408356');
  /// ```
  String create({ required String channelId }) => Uri(pathSegments: ['channels', channelId, 'messages']).path;

  /// Crosspost channel message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#crosspost-message)
  /// ```dart
  /// final uri = http.endpoints.channels.crosspost('1150892323245408356', '1150892323245408356');
  /// ```
  String crosspost({ required String channelId, required String messageId }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'crosspost']).path;

  /// Create reaction from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#create-reaction)
  /// ```dart
  /// final uri = http.endpoints.channels.createReaction('1150892323245408356', '1150892323245408356', '👍');
  /// ```
  String createReaction({ required String channelId, required String messageId, required String emoji }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'reactions', emoji, '@me']).path;

  /// Delete own reaction from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#delete-own-reaction)
  /// ```dart
  /// final uri = http.endpoints.channels.deleteOwnReaction('1150892323245408356', '1150892323245408356', '👍');
  /// ```
  String deleteOwnReaction({ required String channelId, required String messageId, required String emoji }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'reactions', emoji, '@me']).path;

  /// Delete user reaction from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#delete-user-reaction)
  /// ```dart
  /// final uri = http.endpoints.channels.deleteUserReaction('1150892323245408356', '1150892323245408356', '👍', '1150892323245408356');
  /// ```
  String deleteUserReaction({ required String channelId, required String messageId, required String emoji, required String userId }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'reactions', emoji, userId]).path;

  /// Get reactions from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#get-reactions)
  /// ```dart
  /// final uri = http.endpoints.channels.getReactions('1150892323245408356', '1150892323245408356', '👍');
  /// ```
  String getReactions({ required String channelId, required String messageId, required String emoji }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'reactions', emoji]).path;

  /// Delete all reactions from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#delete-all-reactions)
  /// ```dart
  /// final uri = http.endpoints.channels.deleteAllReactions('1150892323245408356', '1150892323245408356');
  /// ```
  String deleteAllReactions({ required String channelId, required String messageId }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'reactions']).path;

  /// Delete all reactions for emoji from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#delete-all-reactions-for-emoji)
  /// ```dart
  /// final uri = http.endpoints.channels.deleteAllReactionsForEmoji('1150892323245408356', '1150892323245408356', '👍');
  /// ```
  String deleteAllReactionsForEmoji({ required String channelId, required String messageId, required String emoji }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'reactions', emoji]).path;

  /// Edit message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#edit-message)
  /// ```dart
  /// final uri = http.endpoints.channels.edit('1150892323245408356', '1150892323245408356');
  /// ```
  String edit({ required String channelId, required String messageId }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId]).path;

  /// Delete message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#delete-message)
  /// ```dart
  /// final uri = http.endpoints.channels.delete('1150892323245408356', '1150892323245408356');
  /// ```
  String delete({ required String channelId, required String messageId }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId]).path;

  /// Bulk delete messages from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#bulk-delete-messages)
  /// ```dart
  /// final uri = http.endpoints.channels.bulkDelete('1150892323245408356');
  /// ```
  String bulkDelete({ required String channelId }) => Uri(pathSegments: ['channels', channelId, 'messages', 'bulk-delete']).path;

  /// Edit channel permission from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#edit-channel-permissions)
  /// ```dart
  /// final uri = http.endpoints.channels.editChannelPermissions('1150892323245408356', '1234');
  /// ```
  String editChannelPermissions({ required String channelId, required String overwriteId }) =>
      Uri(pathSegments: ['channels', channelId, 'permissions', overwriteId]).path;

  /// Get channel invites from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#get-channel-invites)
  /// ```dart
  /// final uri = http.endpoints.channels.getChannelInvites('1150892323245408356');
  /// ```
  String getChannelInvites({ required String channelId }) => Uri(pathSegments: ['channels', channelId, 'invites']).path;

  /// Create channel invite from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#create-channel-invite)
  /// ```dart
  /// final uri = http.endpoints.channels.createChannelInvite('1150892323245408356');
  /// ```
  String createChannelInvite({ required String channelId }) => Uri(pathSegments: ['channels', channelId, 'invites']).path;

  /// Delete channel permission from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#delete-channel-permission)
  /// ```dart
  /// final uri = http.endpoints.channels.deleteChannelPermission('1150892323245408356', '1234');
  /// ```
  String deleteChannelPermission({ required String channelId, required String overwriteId }) =>
      Uri(pathSegments: ['channels', channelId, 'permissions', overwriteId]).path;

  /// Follow news channel from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#follow-news-channel)
  /// ```dart
  /// final uri = http.endpoints.channels.followNewsChannel('1150892323245408356');
  /// ```
  String followNewsChannel({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'followers']).path;

  /// Trigger typing indicator from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#trigger-typing-indicator)
  /// ```dart
  /// final uri = http.endpoints.channels.triggerTypingIndicator('1150892323245408356');
  /// ```
  String triggerTypingIndicator({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'typing']).path;

  /// Get pinned messages from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#get-pinned-messages)
  /// ```dart
  /// final uri = http.endpoints.channels.getPinnedMessages('1150892323245408356');
  /// ```
  String getPinnedMessages({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'pins']).path;

  /// Add recipient to group DM from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#group-dm-add-recipient)
  /// ```dart
  /// final uri = http.endpoints.channels.groupDmAddRecipient('1150892323245408356', '1234');
  /// ```
  String groupDmAddRecipient({ required String channelId, required String userId }) =>
      Uri(pathSegments: ['channels', channelId, 'recipients', userId]).path;

  /// Remove recipient from group DM from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#group-dm-remove-recipient)
  /// ```dart
  /// final uri = http.endpoints.channels.groupDmRemoveRecipient('1150892323245408356', '1234');
  /// ```
  String groupDmRemoveRecipient({ required String channelId, required String userId }) =>
      Uri(pathSegments: ['channels', channelId, 'recipients', userId]).path;

  /// Start thread with message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#start-thread-with-message)
  /// ```dart
  /// final uri = http.endpoints.channels.startThreadWithMessage('1150892323245408356', '1150892323245408356');
  /// ```
  String startThreadWithMessage({ required String channelId, required String messageId }) =>
      Uri(pathSegments: ['channels', channelId, 'messages', messageId, 'threads']).path;

  /// Start thread without message from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#start-thread-without-message)
  /// ```dart
  /// final uri = http.endpoints.channels.startThreadWithoutMessage('1150892323245408356');
  /// ```
  String startThreadWithoutMessage({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'threads']).path;

  /// Join thread from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#join-thread)
  /// ```dart
  /// final uri = http.endpoints.channels.joinThread('1150892323245408356');
  /// ```
  String joinThread({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'thread-members', '@me']).path;

  /// Add thread member from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#add-thread-member)
  /// ```dart
  /// final uri = http.endpoints.channels.addThreadMember('1150892323245408356', '1234');
  /// ```
  String addThreadMember({ required String channelId, required String userId }) =>
      Uri(pathSegments: ['channels', channelId, 'thread-members', userId]).path;

  /// Leave thread from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#leave-thread)
  /// ```dart
  /// final uri = http.endpoints.channels.leaveThread('1150892323245408356');
  /// ```
  String leaveThread({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'thread-members', '@me']).path;

  /// Remove thread member from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#remove-thread-member)
  /// ```dart
  /// final uri = http.endpoints.channels.removeThreadMember('1150892323245408356', '1234');
  /// ```
  String removeThreadMember({ required String channelId, required String userId }) =>
      Uri(pathSegments: ['channels', channelId, 'thread-members', userId]).path;

  /// List active threads from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#list-active-threads)
  /// ```dart
  /// final uri = http.endpoints.channels.listActiveThreads('1150892323245408356');
  /// ```
  String listActiveThreads({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'threads', 'active']).path;

  /// List public archived threads from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#list-public-archived-threads)
  /// ```dart
  /// final uri = http.endpoints.channels.listPublicArchivedThreads('1150892323245408356');
  /// ```
  String listPublicArchivedThreads({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'threads', 'archived', 'public']).path;

  /// List private archived threads from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#list-private-archived-threads)
  /// ```dart
  /// final uri = http.endpoints.channels.listPrivateArchivedThreads('1150892323245408356');
  /// ```
  String listPrivateArchivedThreads({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'threads', 'archived', 'private']).path;

  /// List thread members from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/channel#list-thread-members)
  /// ```dart
  /// final uri = http.endpoints.channels.listThreadMembers('1150892323245408356');
  /// ```
  String listThreadMembers({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'thread-members']).path;
}