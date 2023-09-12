/// [Webhook] repository
/// Related official [documentation](https://discord.com/developers/docs/resources/webhook)
final class WebhookRepository {
  /// Create a [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#create-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.create(channelId: '1234567890');
  /// ```
  String create({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'webhooks']).path;

  /// Get a [Channel] [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#get-channel-webhooks) documentation
  /// ```dart
  /// final webhooks = http.endpoints.webhooks.getChannel(channelId: '1234567890');
  /// ```
  String getChannel({ required String channelId }) =>
      Uri(pathSegments: ['channels', channelId, 'webhooks']).path;

  /// Get a [Guild] [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#get-guild-webhooks) documentation
  /// ```dart
  /// final webhooks = http.endpoints.webhooks.getGuild(guildId: '1234567890');
  /// ```
  String getGuild({ required String guildId }) =>
      Uri(pathSegments: ['guilds', guildId, 'webhooks']).path;

  /// Get a [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#get-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.get(webhookId: '1234567890');
  /// ```
  String get({ required String webhookId }) =>
      Uri(pathSegments: ['webhooks', webhookId]).path;

  /// Get a [Webhook] with a [Token]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#get-webhook-with-token) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.getWithToken(token: '1234567890');
  /// ```
  String getWithToken({ required String webhookId, required String token }) =>
      Uri(pathSegments: ['webhooks', webhookId, token]).path;

  /// Modify a [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#modify-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.modify(webhookId: '1234567890');
  /// ```
  String modify({ required String webhookId }) =>
      Uri(pathSegments: ['webhooks', webhookId]).path;

  /// Modify a [Webhook] with a token
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#modify-webhook-with-token) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.modify(token: '1234567890');
  /// ```
  String modifyWithToken({ required String webhookId, required String token }) =>
      Uri(pathSegments: ['webhooks', webhookId, token]).path;

  /// Delete a [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#delete-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.delete(webhookId: '1234567890');
  /// ```
  String delete({ required String webhookId }) =>
      Uri(pathSegments: ['webhooks', webhookId]).path;

  /// Delete a [Webhook] with a token
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#delete-webhook-with-token) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.deleteWithToken(webhookId: '1234567890', token: '1234');
  /// ```
  String deleteWithToken({ required String webhookId, required String token }) =>
      Uri(pathSegments: ['webhooks', webhookId, token]).path;

  /// Execute a [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#execute-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.execute(webhookId: '1234567890', token: '1234');
  /// ```
  String execute({ required String webhookId, required String token }) =>
      Uri(pathSegments: ['webhooks', webhookId, token]).path;

  /// Execute a [Slack] compatible [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#execute-slackcompatible-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.executeForSlack(webhookId: '1234567890', token: '1234');
  /// ```
  String executeForSlack({ required String webhookId, required String token }) =>
      Uri(pathSegments: ['webhooks', webhookId, token, 'slack']).path;

  /// Execute a [GitHub] compatible [Webhook]
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#execute-githubcompatible-webhook) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.executeForGithub(webhookId: '1234567890', token: '1234');
  /// ```
  String executeForGithub({ required String webhookId, required String token }) =>
      Uri(pathSegments: ['webhooks', webhookId, token, 'github']).path;

  /// Get a [Webhook] message
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#get-webhook-message) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.getMessage(
  ///   webhookId: '1234567890',
  ///   token: '1234',
  ///   messageId: '1234'
  /// );
  /// ```
  String getMessage({ required String webhookId, required String token, required String messageId }) =>
      Uri(pathSegments: ['webhooks', webhookId, token, 'messages', messageId]).path;

  /// Edit a [Webhook] message
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#edit-webhook-message) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.editMessage(
  ///   webhookId: '1234567890',
  ///   token: '1234',
  ///   messageId: '1234'
  /// );
  /// ```
  String editMessage({ required String webhookId, required String token, required String messageId }) =>
      Uri(pathSegments: ['webhooks', webhookId, token, 'messages', messageId]).path;

  /// Delete a [Webhook] message
  /// Related to the official [Discord API](https://discord.com/developers/docs/resources/webhook#delete-webhook-message) documentation
  /// ```dart
  /// final webhook = http.endpoints.webhooks.deleteMessage(
  ///   webhookId: '1234567890',
  ///   token: '1234',
  ///   messageId: '1234'
  /// );
  /// ```
  String deleteMessage({ required String webhookId, required String token, required String messageId }) =>
      Uri(pathSegments: ['webhooks', webhookId, token, 'messages', messageId]).path;
}