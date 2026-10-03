import '../../domain/entities/email.dart';

class EmailModel extends Email {
  const EmailModel({
    required super.id,
    required super.threadId,
    required super.from,
    required super.to,
    required super.subject,
    required super.snippet,
    required super.receivedAt,
    required super.isUnread,
    required super.bucket,
    required super.attachments,
  });
}
