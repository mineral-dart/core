import 'package:mineral/api/common/contracts/message_contract.dart';
import 'package:mineral/api/server/contracts/guild_message_mention_contract.dart';

abstract interface class GuildMessageContract implements MessageContract {
  abstract final GuildMessageMentionContract mentions;
}