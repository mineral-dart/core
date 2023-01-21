import 'package:mineral/src/internal/services/http_service/adapters/default/get_request_builder_adapter.dart';
import 'package:mineral/src/internal/services/http_service/adapters/default/post_request_builder_adapter.dart';
import 'package:mineral/src/internal/services/http_service/http_adapter_contract.dart';
import 'package:mineral/src/internal/services/http_service/http_method.dart';
import 'package:mineral_ioc/ioc.dart';

class HttpService<GetterAdapter extends HttpAdapterContract, PostAdapter, DestroyAdapter> extends MineralService {
  String baseUrl;
  final Map<String, String> headers = {};

  HttpService(this.baseUrl);

  void defineHeader ({ required String header, required String value }) {
    headers.putIfAbsent(header, () => value);
  }

  void removeHeader (String header) {
    headers.remove(header);
  }

  GetterAdapter get ({ required String url }) =>
      GetRequestBuilderAdapter(HttpMethod.post, baseUrl, url, headers) as GetterAdapter;

  PostAdapter post ({ required String url }) =>
      PostRequestBuilderAdapter(HttpMethod.post, baseUrl, url, headers) as PostAdapter;

  PostAdapter put ({ required String url }) =>
      PostRequestBuilderAdapter(HttpMethod.put, baseUrl, url, headers) as PostAdapter;

  PostAdapter patch ({ required String url }) =>
      PostRequestBuilderAdapter(HttpMethod.patch, baseUrl, url, headers) as PostAdapter;

  DestroyAdapter destroy ({ required String url }) =>
      PostRequestBuilderAdapter(HttpMethod.destroy, baseUrl, url, headers) as DestroyAdapter;
}