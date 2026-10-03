import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/mail_bucket.dart';
import '../repositories/categorization_repository.dart';

class ClassifyEmailParams {
  final String fromAddress;
  final List<String> labels;
  final String? listUnsubscribe;
  final String subject;
  final String snippet;
  final bool hasCalendar;
  final bool isVip;
  final bool isUnread;

  const ClassifyEmailParams({
    required this.fromAddress,
    required this.labels,
    this.listUnsubscribe,
    required this.subject,
    required this.snippet,
    required this.hasCalendar,
    required this.isVip,
    required this.isUnread,
  });
}

class ClassifyEmail implements UseCase<MailBucket, ClassifyEmailParams> {
  final CategorizationRepository repository;
  const ClassifyEmail(this.repository);

  @override
  Future<Either<Failure, MailBucket>> call(ClassifyEmailParams params) {
    return repository.classifyEmail(
      fromAddress: params.fromAddress,
      labels: params.labels,
      listUnsubscribe: params.listUnsubscribe,
      subject: params.subject,
      snippet: params.snippet,
      hasCalendar: params.hasCalendar,
      isVip: params.isVip,
      isUnread: params.isUnread,
    );
  }
}
