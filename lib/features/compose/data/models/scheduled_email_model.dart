import '../../domain/entities/scheduled_email.dart';

class ScheduledEmailModel extends ScheduledEmail {
  const ScheduledEmailModel({
    required super.id,
    required super.to,
    required super.subject,
    required super.body,
    required super.scheduledAt,
    required super.status,
  });
}
