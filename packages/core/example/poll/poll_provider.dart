import 'package:mineral/api.dart';

import 'poll_command.dart';
import 'vote_buttons.dart';

final class PollProvider extends Provider {
  final Client _client;

  PollProvider(this._client) {
    _client
      ..register<PollCommand>(PollCommand.new)
      ..register<VoteYesButton>(VoteYesButton.new)
      ..register<VoteNoButton>(VoteNoButton.new)
      ..register<PollResultsButton>(PollResultsButton.new);
  }
}
