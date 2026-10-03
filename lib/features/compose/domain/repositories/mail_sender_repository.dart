import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/draft_email.dart';
import '../entities/scheduled_email.dart';

abstract class MailSenderRepository {
  Future<Either<Failure, void>> sendEmail({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  });
  Future<Either<Failure, void>> saveDraft(DraftEmail draft);
  Future<Either<Failure, void>> scheduleEmail(ScheduledEmail email);
  Future<Either<Failure, void>> cancelScheduledEmail(String id);
}
