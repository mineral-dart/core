import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/infrastructure/commons/utils.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSubscriptionSerializer implements SerializerContract<ServerSubscription> {
  @override
  Future<void> normalize(Map<String, dynamic> json) async {
    throw UnimplementedError();
  }

  @override
  ServerSubscription serialize(Map<String, dynamic> json) {
    return ServerSubscription(
      tier: findInEnum(PremiumTier.values, json['premium_tier']),
      subscriptionCount: json['premium_subscription_count'],
      hasEnabledProgressBar: json['premium_progress_bar_enabled'],
    );
  }

  @override
  Map<String, dynamic> deserialize(ServerSubscription object) {
    return {
      'premium_tier': object.tier.value,
      'premium_subscription_count': object.subscriptionCount,
      'premium_progress_bar_enabled': object.hasEnabledProgressBar,
    };
  }
}
