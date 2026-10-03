import 'package:equatable/equatable.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import 'attachment.dart';

class Email extends Equatable {
  final String id;
  final String threadId;
  final String from;
  final String to;
  final String subject;
  final String snippet;
  final DateTime receivedAt;
  final bool isUnread;
  final MailBucket bucket;
  final List<Attachment> attachments;

  const Email({
    required this.id,
    required this.threadId,
    required this.from,
    required this.to,
    required this.subject,
    required this.snippet,
    required this.receivedAt,
    required this.isUnread,
    required this.bucket,
    required this.attachments,
  });

  @override
  List<Object?> get props => [id, threadId, from, to, subject, snippet, receivedAt, isUnread, bucket, attachments];
}
