class Vanity { // todo set extends to invite ?
  String code;
  String? uses;

  Vanity(this.code, this.uses);

  factory Vanity.from(final payload) {
    return Vanity(
      payload['code'],
      payload['uses'],
    );
  }
}