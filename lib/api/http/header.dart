final class Header {
  final String key;
  final String value;

  Header(this.key, this.value);

  Header.contentType(String value) : this('Content-Type', value);
  Header.accept(String value) : this('Accept', value);
  Header.authorization(String value) : this('Authorization', value);
  Header.userAgent(String value) : this('User-Agent', value);
}
