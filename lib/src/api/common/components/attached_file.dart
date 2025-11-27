import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mineral/api.dart';

/// Represents a file attachment in a Discord message.
///
/// [AttachedFile] allows attaching files from local storage or network URLs
/// to messages. Supports images, videos, documents, and other file types.
///
/// ## Usage
///
/// ```dart
/// // Attach local file
/// final localFile = AttachedFile.fromFile(
///   File('assets/document.pdf'),
///   'document.pdf',
///   description: 'Important document',
/// );
///
/// // Attach from network URL
/// final networkFile = await AttachedFile.fromNetwork(
///   'https://example.com/image.jpg',
///   'image.jpg',
///   spoiler: false,
/// );
///
/// // From MediaItem
/// final media = MediaItem.fromFile(File('data.json'), 'data.json');
/// final attachedFile = await AttachedFile.fromMediaItem(media);
///
/// // Send message with attachments
/// await channel.send(
///   MessageBuilder.content('Here are the files:')
///     ..addAttachedFile(localFile)
///     ..addAttachedFile(networkFile),
/// );
/// ```
///
/// ## File Types
///
/// - **Images**: PNG, JPEG, GIF, WebP (displayed inline)
/// - **Videos**: MP4, WebM, MOV (displayed inline)
/// - **Documents**: PDF, TXT, JSON, etc. (shown as download)
/// - **Archives**: ZIP, RAR, etc.
///
/// ## Features
///
/// - Spoiler tags to hide previews
/// - Descriptions for accessibility
/// - Automatic content type detection
/// - Dimension specification for images/videos
///
/// ## Limits
///
/// - File size: 10MB (Up to 100MB with Nitro)
///
/// See also:
/// - [MediaItem] for creating media items
/// - [MessageBuilder] for building messages with files
final class AttachedFile implements MessageComponent {
  /// The media item representing the file.
  MediaItem item;

  /// Creates an [AttachedFile] from a local file.
  ///
  /// Example:
  /// ```dart
  /// final file = File('assets/image.png');
  /// final attachedFile = AttachedFile.fromFile(file, 'image.png', spoiler: false);
  /// ```
  factory AttachedFile.fromFile(
    File file,
    String name, {
    bool? spoiler,
    String? proxyUrl,
    int? height,
    int? width,
    String? contentType,
    String? description,
  }) {
    final mediaItem = MediaItem.fromFile(
      file,
      name,
      spoiler: spoiler,
      proxyUrl: proxyUrl,
      height: height,
      width: width,
      contentType: contentType,
      description: description,
    );
    return AttachedFile._(mediaItem);
  }

  /// Private constructor. Use factory methods instead.
  AttachedFile._(this.item);

  /// The type of this component.
  ComponentType get type => ComponentType.file;

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.value, ...item.toJson()};
  }

  /// Creates an [AttachedFile] from a [MediaItem].
  ///
  /// If the [MediaItem] was created using [MediaItem.fromNetwork] and doesn't
  /// have bytes yet, this method will fetch the file from the network URL.
  ///
  /// Example:
  /// ```dart
  /// final mediaItem = MediaItem.fromNetwork('https://example.com/image.png');
  /// final attachedFile = await AttachedFile.fromMediaItem(mediaItem);
  /// ```
  static Future<AttachedFile> fromMediaItem(MediaItem mediaItem) async {
    // If bytes are already present (e.g., from MediaItem.fromFile), use them directly
    if (mediaItem.bytes != null) {
      return AttachedFile._(mediaItem);
    }

    // If no bytes, fetch from the network URL
    final uri = Uri.parse(mediaItem.url);
    final response = await http.get(uri);

    // Extract filename from the URL or use a default
    final name =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'file.txt';

    // Create a new MediaItem with the fetched bytes and attachment:// URL
    final media = MediaItem.fromNetwork(
      'attachment://$name',
      spoiler: mediaItem.spoiler,
      proxyUrl: mediaItem.proxyUrl,
      height: mediaItem.height,
      width: mediaItem.width,
      contentType: mediaItem.contentType,
      description: mediaItem.description,
    )..bytes = response.bodyBytes;

    return AttachedFile._(media);
  }

  /// Creates an [AttachedFile] by fetching a file from a network URL.
  ///
  /// This method downloads the file from the specified [url] and prepares it
  /// for attachment to a Discord message. The file is automatically converted
  /// to use Discord's `attachment://` protocol with the provided [name].
  ///
  /// Example:
  /// ```dart
  /// final attachedFile = await AttachedFile.fromNetwork(
  ///   'https://example.com/data/data.json',
  ///   'data.json',
  ///   spoiler: true,
  /// );
  ///
  /// final builder = MessageBuilder()
  ///   ..addText('Check out these datas!')
  ///   ..addFile(attachedFile);
  /// ```
  static Future<AttachedFile> fromNetwork(
    String url,
    String name, {
    bool? spoiler,
    String? proxyUrl,
    int? height,
    int? width,
    String? contentType,
    String? description,
  }) async {
    // Fetch bytes from the network URL
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    // Create a MediaItem with the fetched bytes
    final media = MediaItem.fromNetwork(
      'attachment://$name',
      spoiler: spoiler,
      proxyUrl: proxyUrl,
      height: height,
      width: width,
      contentType: contentType,
      description: description,
    )
      ..bytes = response.bodyBytes
      ..spoiler = spoiler;

    return AttachedFile._(media);
  }
}
