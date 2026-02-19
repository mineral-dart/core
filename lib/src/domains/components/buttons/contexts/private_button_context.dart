import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class PrivateButtonContext extends ComponentContextBase
    implements ButtonContext {
  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  final Snowflake channelId;

  final Snowflake messageId;

  final Snowflake? authorId;

  PrivateButtonContext({
    required super.id,
    required super.applicationId,
    required super.token,
    required super.version,
    required super.customId,
    required this.authorId,
    required this.channelId,
    required this.messageId,
  });

  Future<User> resolveAuthor({bool force = false}) async {
    final author = await _dataStore.user.get(authorId!.value, force);
    return author!;
  }

  Future<ServerChannel> resolveChannel({bool force = false}) async {
    final channel =
        await _dataStore.channel.get<ServerChannel>(channelId.value, force);
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
