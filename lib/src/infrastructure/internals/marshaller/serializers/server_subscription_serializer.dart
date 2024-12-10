import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/premium_tier.dart';
import 'package:mineral/src/api/server/server_subscription.dart';
import 'package:mineral/src/domains/commons/utils/utils.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerSubscriptionSerializer
    implements SerializerContract<ServerSubscription> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'premium_tier': json['premium_tier'],
      'premium_subscription_count': json['premium_subscription_count'],
      'premium_progress_bar_enabled': json['premium_progress_bar_enabled'],
    };

    final cacheKey = _marshaller.cacheKey.serverSubscription(json['server_id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
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
