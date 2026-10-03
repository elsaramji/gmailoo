import 'package:fpdart/fpdart.dart';
import 'package:gmailoo/core/error/failures.dart';
import 'package:gmailoo/core/usecase/usecase.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import '../entities/email.dart';
import '../repositories/mail_reader_repository.dart';

class GetEmailsByBucket implements UseCase<List<Email>, MailBucket> {
  final MailReaderRepository repository;
  const GetEmailsByBucket(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(MailBucket bucket) {
    return repository.getEmailsByBucket(bucket);
  }
}
