import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class PrivateButtonContext implements ButtonContext {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  final Snowflake id;

  @override
  final Snowflake applicationId;

  @override
  final String token;

  @override
  final int version;

  @override
  final String customId;

  final Snowflake channelId;

  final Snowflake messageId;

  final Snowflake? authorId;

  late final InteractionContract interaction;

  PrivateButtonContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.authorId,
    required this.channelId,
    required this.messageId,
  }) {
    interaction = Interaction(token, id);
  }

  Future<User> resolveAuthor({bool force = false}) async {
    final author = await _dataStore.user.get(authorId!.value, force);
    return author!;
  }

  Future<ServerChannel> resolveChannel({bool force = false}) async {
    final channel = await _dataStore.channel.get<ServerChannel>(channelId.value, force);
    return channel!;
  }

  /// Resolves the message that the button was clicked on
  /// ```dart
  /// final message = await ctx.resolveMessage();
  /// ```
  Future<ServerMessage> resolveMessage({bool force = false}) async {
    final message = await _dataStore.message
        .get<ServerMessage>(channelId.value, messageId.value, force);
    return message!;
  }
}
