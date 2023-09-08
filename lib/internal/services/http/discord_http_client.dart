import 'package:http/http.dart';
import 'package:mineral/internal/fold/injectable.dart';
import 'package:mineral/internal/services/http/builders/discord_delete_builder.dart';
import 'package:mineral/internal/services/http/builders/discord_get_builder.dart';
import 'package:mineral/internal/services/http/builders/discord_patch_builder.dart';
import 'package:mineral/internal/services/http/builders/discord_post_builder.dart';
import 'package:mineral/internal/services/http/builders/discord_put_builder.dart';
import 'package:mineral/internal/services/http/discord_http_request_dispatcher.dart';
import 'package:mineral/services/http/header_bucket.dart';
import 'package:mineral/services/http/contracts/http_client_contract.dart';

/// Discord HTTP Client used to make requests to a Discord API.
/// Related to the official Discord API documentation: https://discord.com/developers/docs/intro
/// ```dart
/// final DiscordHttpClient client = DiscordHttpClient(baseUrl: '/');
/// ```
class DiscordHttpClient extends Injectable implements HttpClientContract<DiscordHttpRequestDispatcher> {
  /// Client used to make requests
  final Client _client = Client();

  /// Dispatcher used to dispatch requests under pools
  @override
  late final DiscordHttpRequestDispatcher dispatcher;

  /// Base URL of this
  @override
  final String baseUrl;

  /// Headers of this
  @override
  final HeaderBucket headers = HeaderBucket();

  DiscordHttpClient({ required this.baseUrl, Map<String, String> headers = const {} }) {
    dispatcher = DiscordHttpRequestDispatcher(_client);
    this.headers.addAll(headers);
  }

  /// Create a GET request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final response = await client.get('/foo').build();
  /// ```
  @override
  DiscordGetBuilder get(String url) {
    final request = Request('GET', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DiscordGetBuilder(dispatcher, request);
  }

  /// Create a POST request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.post('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  @override
  DiscordPostBuilder post(String url) {
    final request = Request('POST', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DiscordPostBuilder(dispatcher, request);
  }

  /// Create a PUT request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.put('/foo/:id')
  ///  .payload({ 'name': 'John Doe' })
  ///  .build();
  ///  ```
  @override
  DiscordPutBuilder put(String url) {
    final request = Request('PUT', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DiscordPutBuilder(dispatcher, request);
  }

  /// Create a PATCH request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// final foo = await client.patch('/foo/:id')
  ///   .payload({ 'name': 'John Doe' })
  ///   .build();
  /// ```
  @override
  DiscordPatchBuilder patch(String url) {
    final request = Request('PATCH', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DiscordPatchBuilder(dispatcher, request);
  }

  /// Create a DELETE request
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// await client.delete('/foo/:id').build();
  /// ```
  @override
  DiscordDeleteBuilder delete(String url) {
    final request = Request('DELETE', Uri.parse('$baseUrl$url'))
      ..headers.addAll(headers.all);

    return DiscordDeleteBuilder(dispatcher, request);
  }
}
