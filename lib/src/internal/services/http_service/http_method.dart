enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  destroy('DELETE');

  final String uid;
  const HttpMethod(this.uid);
}