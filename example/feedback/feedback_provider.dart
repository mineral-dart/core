import 'package:mineral/api.dart';

import 'feedback_button.dart';
import 'feedback_command.dart';
import 'feedback_modal.dart';

final class FeedbackProvider extends Provider {
  final Client _client;

  FeedbackProvider(this._client) {
    _client
      ..register<FeedbackCommand>(FeedbackCommand.new)
      ..register<FeedbackButton>(FeedbackButton.new)
      ..register<FeedbackModal>(FeedbackModal.new);
  }
}
