import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';

final class PollAnswerVote<T extends BaseMessage> {
  int id;
  List<User> voters;
  Server? server;
  T message;

  PollAnswerVote({
    required this.id,
    required this.voters,
    required this.message,
    this.server
  });

  static Future<PollAnswerVote<T>> fromJson<T extends BaseMessage>(Map<String, dynamic> json, Server? server, T message) async {
    final marshaller = ioc.resolve<MarshallerContract>();
    final List<User> voters = [];

    for (final voter in json['users']) {
      final payload = await marshaller.serializers.user.normalize(voter);
      final user = await marshaller.serializers.user.serialize(payload);
      voters.add(user);
    }

    return PollAnswerVote(
      id: json['id'] ?? Snowflake.parse(json['answer_id']),
      voters: voters,
      message: message,
      server: server,
    );
  }
}
