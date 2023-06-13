import 'package:mineral/core/api.dart';

class Display {
  final String uid;
  final Map<Lang, String> translations;

  Display(this.uid, { this.translations = const {} });

  Map<String, dynamic> get serialize =>
    translations.entries.fold({}, (previousValue, element) => {
      ...previousValue,
      element.key.uid: element.value
    });
}