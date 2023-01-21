import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mineral/exception.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral/src/internal/services/http_service/adapters/discord_api/destroy_discord_request_builder_adapter.dart';
import 'package:mineral/src/internal/services/http_service/adapters/discord_api/get_discord_request_builder_adapter.dart';
import 'package:mineral/src/internal/services/http_service/adapters/discord_api/post_discord_request_builder_adapter.dart';
import 'package:mineral/src/internal/services/http_service/http_method.dart';
import 'package:mineral/src/internal/services/http_service/http_service.dart';

class DiscordApiHttpService extends HttpService<GetDiscordRequestBuilderAdapter, PostDiscordRequestBuilderAdapter, DestroyDiscordRequestBuilderAdapter> {
  DiscordApiHttpService(super.baseUrl);

  @override
  GetDiscordRequestBuilderAdapter get ({ required String url }) =>
      GetDiscordRequestBuilderAdapter(HttpMethod.get, baseUrl, url, headers, (http.Response response) => responseWrapper(response));

  @override
  PostDiscordRequestBuilderAdapter post ({ required String url }) =>
      PostDiscordRequestBuilderAdapter(HttpMethod.post, baseUrl, url, headers, (http.Response response) => responseWrapper(response));

  @override
  PostDiscordRequestBuilderAdapter put ({ required String url }) =>
      PostDiscordRequestBuilderAdapter(HttpMethod.put, baseUrl, url, headers, (http.Response response) => responseWrapper(response));

  @override
  PostDiscordRequestBuilderAdapter patch ({ required String url }) =>
      PostDiscordRequestBuilderAdapter(HttpMethod.patch, baseUrl, url, headers, (http.Response response) => responseWrapper(response));

  @override
  DestroyDiscordRequestBuilderAdapter destroy ({ required String url }) =>
      DestroyDiscordRequestBuilderAdapter(HttpMethod.destroy, baseUrl, url, headers, (http.Response response) => responseWrapper(response));

  http.Response responseWrapper<T> (http.Response response) {
    if (response.statusCode == 400) {
      final dynamic payload = jsonDecode(response.body);

      if (Helper.hasKey('components', payload)) {
        final List components = payload['components'];

        throw ApiException(payload['components'].length > 1
          ? '${response.statusCode} : components at ${components.join(', ')} positions are invalid'
          : '${response.statusCode} : the component at position ${components.first} is invalid'
        );
      }

      if (Helper.hasKey('embeds', payload)) {
        final List<int> components = payload['embeds'];

        throw ApiException(payload['embeds'].length > 1
          ? '${response.statusCode} embeds at ${components.join(', ')} positions are invalid'
          : '${response.statusCode} the embed at position ${components.first} is invalid'
        );
      }

      throw HttpException('${response.statusCode} : ${response.body}');
    }

    return response;
  }
}