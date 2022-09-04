import 'package:mineral/api.dart';

class IntentManager {
  List<Intent> list = [];

  void defined ({ List<Intent>? intents, bool? all }) {
    if (all == true) {
      list = [Intent.all];
      return;
    }

    if (intents != null) {
      list.addAll(intents);
    }
  }
}
