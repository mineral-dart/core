import 'package:mineral/api/common/premium_tier.dart';
import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerSubscriptionSerializer implements SerializerContract<ServerSubscription> {
  final MarshallerContract _marshaller;

  ServerSubscriptionSerializer(this._marshaller);

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
