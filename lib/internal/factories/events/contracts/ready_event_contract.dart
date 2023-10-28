import 'package:mineral/api/common/contracts/client_contract.dart';
import 'package:mineral/internal/factories/events/contracts/event_contract.dart';

abstract interface class ReadyEventContract implements EventContract {
  Future<void> handle (ClientContract guild);
}