import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email_body.dart';
import '../repositories/mail_reader_repository.dart';

class GetEmailBody implements UseCase<EmailBody, String> {
  final MailReaderRepository repository;
  const GetEmailBody(this.repository);

  @override
  Future<Either<Failure, EmailBody>> call(String messageId) {
    return repository.getEmailBody(messageId);
  }
}
