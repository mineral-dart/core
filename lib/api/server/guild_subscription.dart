import 'package:mineral/api/server/enums/premium_tier.dart';
import 'package:mineral/domains/shared/utils.dart';

final class GuildSubscription {
  final PremiumTier tier;
  final int? subscriptionCount;

  GuildSubscription({
    required this.tier,
    required this.subscriptionCount,
  });

  factory GuildSubscription.fromJson(Map<String, dynamic> json) {
    return GuildSubscription(
      tier: findInEnum(PremiumTier.values, json['premium_tier']),
      subscriptionCount: json['premium_subscription_count'],
    );
  }
}
