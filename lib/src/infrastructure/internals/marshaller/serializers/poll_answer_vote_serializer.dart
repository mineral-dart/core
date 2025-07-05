import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/polls/poll_answer_vote.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/services/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class PollAnswerVoteSerializer implements SerializerContract<PollAnswerVote> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'id': json['id'],
      'users': json['users'],
      'message_id': json['message_id'],
      'channel_id': json['channel_id'],
      'server_id': json['server_id'],
    };

    return payload;
  }

  @override
  Future<PollAnswerVote> serialize(Map<String, dynamic> json) async {
    final List<User> voters = [];
    final message = await _datastore.message.get<Message>(json['channel_id'], json['message_id'], false);
    Server? server;
    for (final voter in json['users']) {
      final payload = await _marshaller.serializers.user.normalize(voter);
      final user = await _marshaller.serializers.user.serialize(payload);
      voters.add(user);
    }

    if (json['server_id'] != null) {
      server = await _datastore.server.get(json['server_id'], false);
    }


    return PollAnswerVote(
      id: json['id'] ?? Snowflake.parse(json['id']),
      voters: voters,
      message: message!,
      server: server,
    );
  }

  @override
  Map<String, dynamic> deserialize(PollAnswerVote answer) {
    final users = answer.voters.map((user) {
      return _marshaller.serializers.user.deserialize(user);
    }).toList();

    return {
      'id': answer.id,
      'users': users,
      'message_id': answer.message.id.value,
      'channel_id': answer.message.channelId.value,
      'server_id': answer.server?.id,
    };
  }
}

