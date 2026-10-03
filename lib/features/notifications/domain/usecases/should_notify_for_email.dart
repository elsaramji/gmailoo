import 'package:fpdart/fpdart.dart';
import 'package:gmailoo/core/error/failures.dart';
import 'package:gmailoo/core/usecase/usecase.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
import '../repositories/notification_repository.dart';

class ShouldNotifyParams {
  final bool isVip;
  final MailBucket bucket;
  final DateTime receivedAt;

  const ShouldNotifyParams({
    required this.isVip,
    required this.bucket,
    required this.receivedAt,
  });
}

class ShouldNotifyForEmail implements UseCase<bool, ShouldNotifyParams> {
  final NotificationRepository repository;
  const ShouldNotifyForEmail(this.repository);

  @override
  Future<Either<Failure, bool>> call(ShouldNotifyParams params) {
    return repository.shouldNotify(
      isVip: params.isVip,
      bucket: params.bucket,
      receivedAt: params.receivedAt,
    );
  }
}
