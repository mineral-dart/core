class MessageAttachmentBuilder {
  String filename;
  String url;
  String? description;

  MessageAttachmentBuilder({
    required this.filename,
    required this.url,
    this.description
  });

  Object toJson ({int? id}) {
    return {
      'id': id,
      'filename': filename,
      'description': description
    };
  }

}