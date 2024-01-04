import 'package:mineral/api/server/enums/premium_tier.dart';
import 'package:mineral/domains/shared/utils.dart';

final class GuildSubscription {
  final PremiumTier tier;
  final int? subscriptionCount;
  final bool hasEnabledProgressBar;

  GuildSubscription({
    required this.tier,
    required this.subscriptionCount,
    required this.hasEnabledProgressBar,
  });

  factory GuildSubscription.fromJson(Map<String, dynamic> json) {
    return GuildSubscription(
      tier: findInEnum(PremiumTier.values, json['premium_tier']),
      subscriptionCount: json['premium_subscription_count'],
      hasEnabledProgressBar: json['premium_progress_bar_enabled'],
    );
  }
}
