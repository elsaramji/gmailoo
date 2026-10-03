import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/draft_email.dart';
import '../repositories/mail_sender_repository.dart';

class SaveDraft implements UseCase<void, DraftEmail> {
  final MailSenderRepository repository;
  const SaveDraft(this.repository);

  @override
  Future<Either<Failure, void>> call(DraftEmail params) {
    return repository.saveDraft(params);
  }
}
