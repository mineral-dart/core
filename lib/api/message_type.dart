import 'package:mineral/api/common/types/enhanced_enum.dart';

enum MessageType implements EnhancedEnum<int> {
  initial(0),
  recipientAdd(1),
  recipientRemove(2),
  call(3),
  channelNameChange(4),
  channelIconChange(5),
  channelPinnedMessage(6),
  userJoin(7),
  guildBoost(8),
  guildBoostTier1(9),
  guildBoostTier2(10),
  guildBoostTier3(11),
  channelFollowAdd(12),
  guildDiscoveryDisqualified(14),
  guildDiscoveryRequalified(15),
  guildDiscoveryGracePeriodInitialWarning(16),
  guildDiscoveryGracePeriodFinalWarning(17),
  threadCreated(18),
  reply(19),
  chatInputCommand(20),
  threadStarterMessage(21),
  guildInviteReminder(22),
  contextMenuCommand(23),
  autoModerationAction(24),
  roleSubscriptionPurchase(25),
  interactionPremiumUpsell(26),
  stageStart(27),
  stageEnd(28),
  stageSpeaker(29),
  stageTopic(31),
  guildApplicationPremiumSubscription(32);

  @override
  final int value;
  const MessageType(this.value);
}
