

import 'package:mineral/src/internal/services/console/contracts/theme_contract.dart';

class Theme implements ThemeContract {
  @override
  final String inputPrefix;

  @override
  final String successPrefix;

  @override
  final String errorPrefix;

  @override
  final String booleanPrefix;

  @override
  final String pickedItemPrefix;

  @override
  final String infoPrefix;

  @override
  final String warnPrefix;

  const Theme({
    required this.inputPrefix,
    required this.successPrefix,
    required this.errorPrefix,
    required this.booleanPrefix,
    required this.pickedItemPrefix,
    required this.infoPrefix,
    required this.warnPrefix,
  });
}