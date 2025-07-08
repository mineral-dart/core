import 'package:mineral/api.dart';

abstract class InteractionContract {
  /// Use to reply to the interaction.
  /// Usage:
  ///
  /// ```dart
  /// final interaction = await interaction.reply(content: 'Hello Mineral');
  /// ```
  Future<InteractionContract> reply(
      {required MessageComponentBuilder builder, bool ephemeral = false});

  /// Use to edit the reply to the interaction.
  /// Usage:
  ///
  /// ```dart
  /// final interaction = await interaction.editReply(content: 'New Hello Mineral');
  Future<InteractionContract> editReply(
      {String content,
      List<MessageEmbed> embeds,
      List<MessageComponent> components});

  /// Use to delete the reply to the interaction. Need a reply to delete.
  /// Usage:
  ///
  /// ```dart
  /// await interaction.deleteReply();
  /// ```
  Future<void> deleteReply();

  /// Use to not reply to the interaction, prevent the 'This interaction failed' message.
  /// Usage:
  ///
  /// ```dart
  /// await interaction.noReply();
  /// ```
  Future<void> noReply();

  /// Use to follow up the interaction.
  /// Usage:
  ///
  /// ```dart
  /// final interaction = await interaction.followUp(content: 'Hello Mineral');
  /// ```
  Future<InteractionContract> followUp(
      {String content,
      List<MessageEmbed> embeds,
      List<MessageComponent> components,
      bool ephemeral = false});

  /// Use to edit the follow up message.
  /// Usage:
  ///
  /// ```dart
  /// final interaction = await interaction.editFollowUp(content: 'New Hello Mineral');
  /// ```
  Future<InteractionContract> editFollowUp(
      {String content,
      List<MessageEmbed> embeds,
      List<MessageComponent> components,
      bool ephemeral = false});

  /// Use to delete the follow up message.
  /// Usage:
  ///
  /// ```dart
  /// await interaction.deleteFollowUp();
  /// ```
  Future<void> deleteFollowUp();

  /// Use to defer the interaction, like a loading state.
  /// Usage:
  ///
  /// ```dart
  /// await interaction.defer();
  /// ```
  Future<InteractionContract> wait();

  /// Use to edit the deferred message, delete the deferred message to a simple reply.
  /// Usage:
  ///
  /// ```dart
  /// await interaction.editDefer(content: 'Hello Mineral');
  /// ```
  Future<InteractionContract> editWait(
      {String content,
      List<MessageEmbed> embeds,
      List<MessageComponent> components,
      bool ephemeral = false});

  /// Use to delete the deferred message.
  /// Usage:
  ///
  /// ```dart
  /// await interaction.deleteDefer();
  /// ```
  Future<void> deleteDefer();

  /// Use to send a dialog to the interaction.
  ///
  /// Usage:
  /// ```dart
  /// final dialog = DialogBuilder('unique_custom_id')
  ///   ..setTitle('Hello')
  ///   ..text('hello', (input) => input
  ///     ..setLabel('Hello')
  ///     ..setPlaceholder('World');
  ///   );
  ///
  /// await interaction.dialog(dialog);
  /// ```
  Future<void> dialog(DialogBuilder dialog);
}
