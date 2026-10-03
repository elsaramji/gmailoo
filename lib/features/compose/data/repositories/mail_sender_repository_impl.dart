import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/draft_email.dart';
import '../../domain/entities/scheduled_email.dart';
import '../../domain/repositories/mail_sender_repository.dart';
import '../datasources/compose_local_data_source.dart';
import '../datasources/compose_remote_data_source.dart';
import '../models/draft_email_model.dart';
import '../models/scheduled_email_model.dart';

class MailSenderRepositoryImpl implements MailSenderRepository {
  final ComposeRemoteDataSource remoteDataSource;
  final ComposeLocalDataSource localDataSource;

  const MailSenderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> sendEmail({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  }) async {
    try {
      await remoteDataSource.sendRawEmail(to: to, cc: cc, bcc: bcc, subject: subject, body: body);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDraft(DraftEmail draft) async {
    try {
      await localDataSource.saveDraft(DraftEmailModel(
        id: draft.id,
        to: draft.to,
        cc: draft.cc,
        bcc: draft.bcc,
        subject: draft.subject,
        body: draft.body,
        updatedAt: draft.updatedAt,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> scheduleEmail(ScheduledEmail email) async {
    try {
      await localDataSource.queueScheduledEmail(ScheduledEmailModel(
        id: email.id,
        to: email.to,
        subject: email.subject,
        body: email.body,
        scheduledAt: email.scheduledAt,
        status: email.status,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelScheduledEmail(String id) async {
    try {
      await localDataSource.removeScheduledEmail(id);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
