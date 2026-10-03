import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_sender_repository.dart';

class SendEmailParams {
  final String to;
  final String? cc;
  final String? bcc;
  final String subject;
  final String body;

  const SendEmailParams({
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    required this.body,
  });
}

class SendEmail implements UseCase<void, SendEmailParams> {
  final MailSenderRepository repository;
  const SendEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(SendEmailParams params) {
    return repository.sendEmail(
      to: params.to,
      cc: params.cc,
      bcc: params.bcc,
      subject: params.subject,
      body: params.body,
    );
  }
}
