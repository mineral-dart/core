import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an Discord partner.
class PartnerFlag extends UserFlagContract {
  PartnerFlag(): super('Partnered Server Owner', 1 << 1, '34306011e46e87f8ef25f3415d3b99ca.svg');
}