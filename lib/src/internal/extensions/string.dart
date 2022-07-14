extension StringFormat on String {

  List<String> _groupIntoWords(String text) {
    RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
    Set<String> symbolSet = {' ', '.', '/', '_', '\\', '-'};

    StringBuffer sb = StringBuffer();
    List<String> words = [];
    bool isAllCaps = text.toUpperCase() == text;

    for (int i = 0; i < text.length; i++) {
      String char = text[i];
      String? nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      bool isEndOfWord = nextChar == null
        || (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps)
        || symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }

  String _getCamelCase({String separator = ''}) {
    List<String> words = _groupIntoWords(this).map(_upperCaseFirstLetter).toList();
    if (_groupIntoWords(this).isNotEmpty) {
      words[0] = words[0].toLowerCase();
    }

    return words.join(separator);
  }

  String _getConstantCase({String separator = '_'}) {
    List<String> words = _groupIntoWords(this).map((word) => word.toUpperCase()).toList();

    return words.join(separator);
  }

  String _getPascalCase({String separator = ''}) {
    List<String> words = _groupIntoWords(this).map(_upperCaseFirstLetter).toList();

    return words.join(separator);
  }

  String _getSentenceCase({String separator = ' '}) {
    List<String> words = _groupIntoWords(this).map((word) => word.toLowerCase()).toList();
    if (_groupIntoWords(this).isNotEmpty) {
      words[0] = _upperCaseFirstLetter(words[0]);
    }

    return words.join(separator);
  }

  String _getSnakeCase({String separator = '_'}) {
    List<String> words = _groupIntoWords(this).map((word) => word.toLowerCase()).toList();

    return words.join(separator);
  }

  String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}';
  }

  String get camelCase => _getCamelCase();
  String get constantCase => _getConstantCase();
  String get sentenceCase => _getSentenceCase();
  String get snakeCase => _getSnakeCase();
  String get pascalCase => _getPascalCase();
}
