import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/core/api.dart';
import 'package:mineral/exception.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral_ioc/ioc.dart';

class HttpService extends MineralService {
  String baseUrl;
  final Map<String, String> _headers = {};

  HttpService({ required this.baseUrl });

  void defineHeader ({ required String header, required String value }) {
    _headers.putIfAbsent(header, () => value);
  }

  void removeHeader (String header) {
    _headers.remove(header);
  }

  Future<http.Response> get ({ required String url, Map<String, String>? headers }) async {
    final response = await http.get(Uri.parse("$baseUrl$url"), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  Future<http.Response> post ({ required String url, required dynamic payload, Map<String, String>? headers }) async {
    final response = await http.post(Uri.parse("$baseUrl$url"), body: jsonEncode(payload), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  Future<http.Response> put ({ required String url, required dynamic payload, Map<String, String>? headers }) async {
    final response = await http.put(Uri.parse("$baseUrl$url"), body: jsonEncode(payload), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  Future<http.Response> patch ({ required String url, required dynamic payload, Map<String, String>? headers }) async {
    final response = await http.patch(Uri.parse("$baseUrl$url"), body: jsonEncode(payload), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  Future<http.Response> destroy ({ required String url, Map<String, String>? headers }) async {
    final response = await http.delete(Uri.parse("$baseUrl$url"), headers: _getHeaders(headers));
    return responseWrapper(response);
  }

  Future<http.Response> postWithFiles({ required String url, required List<http.MultipartFile> files, dynamic payload, Map<String, String>? headers }) async {
    Map<String, String> fields = {};
    if(payload != null) fields.putIfAbsent("payload_json", () => jsonEncode(payload));

    final request = http.MultipartRequest('POST', Uri.parse("$baseUrl$url"))
        ..files.addAll(files)
        ..fields.addAll(fields)
        ..headers.addAll(_getHeaders(headers));

    final response = await request.send();
    return responseWrapper(http.Response.bytes(await response.stream.toBytes(), response.statusCode));
  }

  Map<String, String> _getHeaders (Map<String, String>? headers) {
    Map<String, String> map = Map.from(_headers);

    if (headers != null) {
      map.addAll(headers);
    }

    return map;
  }

  http.Response responseWrapper<T> (http.Response response) {
    if (response.statusCode == 400) {
      final dynamic payload = jsonDecode(response.body);

      if (Helper.hasKey('components', payload)) {
        print(payload);
        final List components = payload['components'];

        throw ApiException(payload['components'].length > 1
          ? '${response.statusCode} : components at ${components.join(', ')} positions are invalid'
          : '${response.statusCode} : the component at position ${components.first} is invalid'
        );
      }

      if (Helper.hasKey('embeds', payload)) {
        final List<int> components = payload['embeds'];

        throw ApiException(payload['embeds'].length > 1
          ? '$response.statusCode embeds at ${components.join(', ')} positions are invalid'
          : '$response.statusCode the embed at position ${components.first} is invalid'
        );
      }

      throw HttpException('${response.statusCode} : ${response.body}');
    }

    return response;
  }
}
