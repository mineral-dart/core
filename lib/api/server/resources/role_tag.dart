import 'package:mineral/api/common/snowflake.dart';

class RoleTag {
  String? botId;
  String? integrationId;
  String? subscriptionListingId;

  RoleTag._({
    this.botId,
    this.integrationId,
    this.subscriptionListingId,
  });

  factory RoleTag.from(final payload) {
    return RoleTag._(
      botId: payload['bot_id'],
      integrationId: payload['integration_id'],
      subscriptionListingId: payload['premium_subscriber'],
    );
  }
}