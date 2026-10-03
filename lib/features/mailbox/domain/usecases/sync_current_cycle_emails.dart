import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_reader_repository.dart';

class SyncCurrentCycleEmails implements UseCase<List<Email>, NoParams> {
  final MailReaderRepository repository;
  const SyncCurrentCycleEmails(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(NoParams params) {
    return repository.syncCycleEmails();
  }
}
