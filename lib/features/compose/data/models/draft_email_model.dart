import '../../domain/entities/draft_email.dart';

class DraftEmailModel extends DraftEmail {
  const DraftEmailModel({
    required super.id,
    required super.to,
    super.cc,
    super.bcc,
    required super.subject,
    required super.body,
    required super.updatedAt,
  });
}
