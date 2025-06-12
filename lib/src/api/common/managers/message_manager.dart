import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/api/common/snowflake.dart';

final class MessageManager<T extends BaseMessage> {
  final Snowflake _channelId;

  MessageManager(this._channelId);

  final DataStoreContract _datastore = ioc.resolve<DataStoreContract>();

  final Map<Snowflake, T> list = {};

  Future<T?> get(Snowflake id) =>
      _datastore.message.get<T>(_channelId.value, id.value, false);

  Future<T> getOrFail(Snowflake id) =>
      _datastore.message.get<T>(_channelId.value, id.value, false) as Future<T>;
}
