import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

final class ServerSubscriptionSerializer implements SerializerContract<ServerSubscription> {
  final MarshallerContract _marshaller;

  ServerSubscriptionSerializer(this._marshaller);

  @override
  ServerSubscription serialize(Map<String, dynamic> json) => ServerSubscription.fromJson(json);

  @override
  Map<String, dynamic> deserialize(ServerSubscription object) {
    throw UnimplementedError();
  }
}
