import 'dart:async';

import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/data_store_part.dart';

final class ChannelPart implements DataStorePart {
  final DataStore _dataStore;

  ChannelPart(this._dataStore);

  FutureOr<void> getChannel(Snowflake id) async {
  }
}
