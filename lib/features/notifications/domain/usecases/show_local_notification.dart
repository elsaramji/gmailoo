import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/notification_repository.dart';

class ShowNotificationParams {
  final String title;
  final String body;
  final String messageId;

  const ShowNotificationParams({
    required this.title,
    required this.body,
    required this.messageId,
  });
}

class ShowLocalNotification implements UseCase<void, ShowNotificationParams> {
  final NotificationRepository repository;
  const ShowLocalNotification(this.repository);

  @override
  Future<Either<Failure, void>> call(ShowNotificationParams params) {
    return repository.showNotification(
      title: params.title,
      body: params.body,
      messageId: params.messageId,
    );
  }
}
