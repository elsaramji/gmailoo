import 'package:fpdart/fpdart.dart';
import 'package:gmailoo/core/error/failures.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import '../entities/email.dart';
import '../entities/email_body.dart';

abstract class MailReaderRepository {
  Future<Either<Failure, List<Email>>> syncCycleEmails();
  Future<Either<Failure, List<Email>>> getEmailsByBucket(MailBucket bucket);
  Future<Either<Failure, EmailBody>> getEmailBody(String messageId);
  Future<Either<Failure, void>> markAsRead(String messageId);
}
