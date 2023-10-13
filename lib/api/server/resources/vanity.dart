class Vanity { // todo set extends to invite ?
  String code;
  String? uses;

  Vanity._(this.code, this.uses);

  factory Vanity.from(final payload) {
    return Vanity._(
      payload['code'],
      payload['uses'],
    );
  }
}