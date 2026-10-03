import 'package:equatable/equatable.dart';

enum ScheduledStatus { pending, sending, sent, failed }

class ScheduledEmail extends Equatable {
  final String id;
  final String to;
  final String subject;
  final String body;
  final DateTime scheduledAt;
  final ScheduledStatus status;

  const ScheduledEmail({
    required this.id,
    required this.to,
    required this.subject,
    required this.body,
    required this.scheduledAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, to, subject, body, scheduledAt, status];
}
