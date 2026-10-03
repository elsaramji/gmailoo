import 'package:fpdart/fpdart.dart';
import 'package:gmailoo/core/error/failures.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';

abstract class NotificationRepository {
  Future<Either<Failure, bool>> shouldNotify({
    required bool isVip,
    required MailBucket bucket,
    required DateTime receivedAt,
  });
  Future<Either<Failure, void>> showNotification({
    required String title,
    required String body,
    required String messageId,
  });
}
