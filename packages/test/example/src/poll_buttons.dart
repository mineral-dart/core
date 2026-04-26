import 'package:mineral_test/mineral_test.dart';

/// "Yes" button on a poll — opens a follow-up modal asking for an optional
/// comment.
final class VoteYesButton extends OnButtonListener {
  @override
  String get customId => 'poll_vote:yes';

  @override
  Future<void> handle(ButtonClick click) async {
    await TestInteractionResponder.showModal(
      interactionId: click.interactionId,
      token: click.token,
      customId: 'poll_comment',
      title: 'Add a comment',
    );
  }
}

/// Modal submitted from the "Yes" button — records the comment and confirms
/// the vote.
final class VoteCommentModal extends OnModalSubmitListener {
  @override
  String get customId => 'poll_comment';

  @override
  Future<void> handle(ModalSubmission submission) async {
    final comment = submission.fields['comment'] ?? '';
    await TestInteractionResponder.reply(
      interactionId: submission.interactionId,
      token: submission.token,
      content: 'Vote recorded with comment: "$comment".',
    );
  }
}
