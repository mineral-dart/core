import 'package:http/http.dart';
import 'package:mineral/core/builders.dart';

class MessageParser {
  String? _content;
  List<EmbedBuilder> _embeds = [];
  List<RowBuilder> _components = [];
  List<AttachmentBuilder>? _attachments = [];
  bool? _tts;


  MessageParser(String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<AttachmentBuilder>? attachments, bool? tts) {
    _content = content;
    _embeds = embeds ?? _embeds;
    _components = components ?? _components;
    _attachments = attachments;
    _tts = tts;
  }

  dynamic toJson() {
    List<MultipartFile> files = [];
    List<dynamic> attachmentList = [];
    if(_attachments != null) {
      for (int i = 0; i < _attachments!.length; i++) {
        AttachmentBuilder attachment = _attachments![i];
        attachmentList.add(attachment.toJson(id: i));
        files.add(attachment.toFile(i));
      }
    }

    return {
      'payload': {
        'tts': _tts,
        'content': _content,
        'embeds': _embeds.map((e) => e.toJson()).toList(),
        'components': _components.map((e) => e.toJson()).toList(),
        'attachments': attachmentList.isNotEmpty ? attachmentList : null
      }, 'files': files
    };
  }
}