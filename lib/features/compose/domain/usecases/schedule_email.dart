import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/scheduled_email.dart';
import '../repositories/mail_sender_repository.dart';

class ScheduleEmail implements UseCase<void, ScheduledEmail> {
  final MailSenderRepository repository;
  const ScheduleEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(ScheduledEmail params) {
    return repository.scheduleEmail(params);
  }
}
