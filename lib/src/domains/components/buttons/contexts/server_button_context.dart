import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/infrastructure/internals/interactions/interaction.dart';

final class ServerButtonContext implements ButtonContext {
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

  late final InteractionContract interaction;

  ServerButtonContext({
    required this.id,
    required this.applicationId,
    required this.token,
    required this.version,
    required this.customId,
    required this.channelId,
    required this.messageId,
  }) {
    interaction = Interaction(token, id);
  }

  /// Resolves the channel that the button was clicked on
  /// ```dart
  /// final channel = await ctx.resolveChannel();
  /// ```
  Future<ServerChannel> resolveChannel({bool force = false}) async {
    final channel = await _dataStore.channel.get<ServerChannel>(
      channelId.value,
      force,
    );
    return channel!;
  }

  /// Resolves the message that the button was clicked on
  /// ```dart
  /// final message = await ctx.resolveMessage();
  /// ```
  Future<ServerMessage> resolveMessage({bool force = false}) async {
    final message = await _dataStore.message.get<ServerMessage>(
      channelId.value,
      messageId.value,
      force,
    );
    return message!;
  }
}
