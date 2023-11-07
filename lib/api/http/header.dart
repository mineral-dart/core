abstract interface class Header {
  abstract final String key;
  abstract final String value;
}

final class HeaderImpl implements Header {
  @override
  final String key;

  @override
  final String value;

  HeaderImpl(this.key, this.value);

  HeaderImpl.contentType(String value) : this('Content-Type', value);
  HeaderImpl.accept(String value) : this('Accept', value);
  HeaderImpl.authorization(String value) : this('Authorization', value);
  HeaderImpl.userAgent(String value) : this('User-Agent', value);
}
