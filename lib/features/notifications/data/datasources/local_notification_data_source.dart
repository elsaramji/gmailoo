abstract class LocalNotificationDataSource {
  Future<void> displayNotification({
    required String title,
    required String body,
    required String messageId,
  });
}
