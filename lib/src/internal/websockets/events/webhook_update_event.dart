import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class WebhookUpdateEvent extends Event {
  final Webhook? _before;
  final Webhook _after;

  WebhookUpdateEvent(this._before, this._after);

  Webhook? get before => _before;
  Webhook get after => _after;
}
