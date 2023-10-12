import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/contracts/private_channel_contract.dart';

final class PrivateChannel implements PrivateChannelContract {
  @override
  final Snowflake id;

  @override
  final String name;

  PrivateChannel({
    required this.id,
    required this.name,
  });
}