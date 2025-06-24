import 'package:mineral/src/domains/services/packets/packet_dispatcher.dart';

abstract interface class PacketListenerContract {
  PacketDispatcherContract get dispatcher;

  void dispose();
}
