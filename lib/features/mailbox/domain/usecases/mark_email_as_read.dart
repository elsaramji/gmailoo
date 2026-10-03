import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_reader_repository.dart';

class MarkEmailAsRead implements UseCase<void, String> {
  final MailReaderRepository repository;
  const MarkEmailAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(String messageId) {
    return repository.markAsRead(messageId);
  }
}
