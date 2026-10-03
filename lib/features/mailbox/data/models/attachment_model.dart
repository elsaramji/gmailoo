import '../../domain/entities/attachment.dart';

class AttachmentModel extends Attachment {
  const AttachmentModel({
    required super.id,
    required super.filename,
    required super.mimeType,
    required super.sizeBytes,
  });
}
