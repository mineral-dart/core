import 'package:mineral/api/server/enums/premium_tier.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerSubscription {
  final PremiumTier tier;
  final int? subscriptionCount;
  final bool hasEnabledProgressBar;

  ServerSubscription({
    required this.tier,
    required this.subscriptionCount,
    required this.hasEnabledProgressBar,
  });

  factory ServerSubscription.fromJson(Map<String, dynamic> json) {
    return ServerSubscription(
      tier: findInEnum(PremiumTier.values, json['premium_tier']),
      subscriptionCount: json['premium_subscription_count'],
      hasEnabledProgressBar: json['premium_progress_bar_enabled'],
    );
  }
}
