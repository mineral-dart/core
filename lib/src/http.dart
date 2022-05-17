import 'package:http/http.dart' as http;

class Http {
  String baseUrl;
  final Map<String, String> _headers = {};

  Http({ required this.baseUrl });

  void defineHeader ({ required String header, required String value }) {
    _headers.putIfAbsent(header, () => value);
  }

  Future<http.Response> get (String url) async {
    return http.get(Uri.parse("$baseUrl$url"), headers: _headers);
  }

  Future<http.Response> post (String url, dynamic payload) async {
    return http.post(Uri.parse("$baseUrl$url"), body: payload, headers: _headers);
  }

  Future<http.Response> put (String url, dynamic payload) async {
    return http.put(Uri.parse("$baseUrl$url"), body: payload, headers: _headers);
  }

  Future<http.Response> destroy (String url) async {
    return http.delete(Uri.parse("$baseUrl$url"), headers: _headers);
  }
}
