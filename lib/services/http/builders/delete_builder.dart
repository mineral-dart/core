import 'package:http/http.dart';
import 'package:mineral/internal/either.dart';
import 'package:mineral/services/http/http_client.dart';

class DeleteBuilder {
  final HttpClient _httpClient;
  final Request _request;

  DeleteBuilder(this._httpClient, this._request);

  Future<EitherContract> build () async {
    return _httpClient.dispatcher.process(_request);
  }
}