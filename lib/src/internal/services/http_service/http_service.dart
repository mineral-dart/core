import 'package:mineral/core/services/http.dart';
import 'package:mineral_ioc/ioc.dart';

class HttpService<GetterAdapter extends HttpAdapterContract, PostAdapter extends HttpAdapterContract, DestroyAdapter extends HttpAdapterContract> extends MineralService {
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
    DestroyRequestBuilderAdapter(HttpMethod.destroy, baseUrl, url, headers) as DestroyAdapter;
}