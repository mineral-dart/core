import 'package:mineral/api.dart';

final class PollAnswerVote {
  Snowflake id;
  List<User> voters;

  PollAnswerVote({
    required this.id,
    required this.voters,
  });
}
