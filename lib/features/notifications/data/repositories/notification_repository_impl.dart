import 'package:fpdart/fpdart.dart';
import 'package:gmailoo/core/error/failures.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/local_notification_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final LocalNotificationDataSource localDataSource;

  const NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> shouldNotify({
    required bool isVip,
    required MailBucket bucket,
    required DateTime receivedAt,
  }) async {
    // Zen notification rule: push ONLY for VIP or Important unread
    final eligible = isVip || bucket == MailBucket.importantUnread;
    return Right(eligible);
  }

  @override
  Future<Either<Failure, void>> showNotification({
    required String title,
    required String body,
    required String messageId,
  }) async {
    try {
      await localDataSource.displayNotification(title: title, body: body, messageId: messageId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
