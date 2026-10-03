import 'package:fpdart/fpdart.dart';
import 'package:gmailoo/core/error/failures.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import '../../domain/entities/email.dart';
import '../../domain/entities/email_body.dart';
import '../../domain/repositories/mail_reader_repository.dart';
import '../datasources/gmail_remote_data_source.dart';
import '../datasources/mail_local_data_source.dart';

class MailReaderRepositoryImpl implements MailReaderRepository {
  final GmailRemoteDataSource remoteDataSource;
  final MailLocalDataSource localDataSource;

  const MailReaderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Email>>> syncCycleEmails() async {
    try {
      final emails = await remoteDataSource.fetchCycleEmails(afterEpoch: 0, beforeEpoch: 0);
      await localDataSource.cacheEmails(emails);
      return Right(emails);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Email>>> getEmailsByBucket(MailBucket bucket) async {
    try {
      final cached = await localDataSource.getCachedEmails(bucket);
      return Right(cached);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmailBody>> getEmailBody(String messageId) async {
    try {
      final cached = await localDataSource.getCachedBody(messageId);
      if (cached != null) return Right(cached);
      final body = await remoteDataSource.fetchEmailBody(messageId);
      await localDataSource.cacheBody(body);
      return Right(body);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    try {
      await localDataSource.updateReadStatus(messageId, true);
      await remoteDataSource.markAsRead(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
