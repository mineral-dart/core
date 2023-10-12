import 'package:mineral/api/common/contracts/base_message_contract.dart';

abstract interface class MessageContract implements BaseMessageContract {
  abstract final bool isPinned;
  abstract final bool isTTS;
  abstract final List<dynamic> embeds;
  abstract final List<dynamic> attachments;
  abstract final List<dynamic> mentionChannels;
  abstract final List<dynamic> mentionRoles;
  abstract final List<dynamic> mentionUsers;
  abstract final List<dynamic> reactions;
  abstract final int timestamp;
  abstract final int editedTimestamp;
  abstract final int flags;
}