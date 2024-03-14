import 'package:mineral/api/server/enums/premium_tier.dart';

final class ServerSubscription {
  final PremiumTier tier;
  final int? subscriptionCount;
  final bool hasEnabledProgressBar;

  ServerSubscription({
    required this.tier,
    required this.subscriptionCount,
    required this.hasEnabledProgressBar,
  });
}
