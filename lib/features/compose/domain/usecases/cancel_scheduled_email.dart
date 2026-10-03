import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_sender_repository.dart';

class CancelScheduledEmail implements UseCase<void, String> {
  final MailSenderRepository repository;
  const CancelScheduledEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.cancelScheduledEmail(id);
  }
}
