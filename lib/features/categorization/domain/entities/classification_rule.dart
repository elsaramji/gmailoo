import 'mail_bucket.dart';

abstract class ClassificationRule {
  MailBucket? classify({
    required List<String> labels,
    required String? listUnsubscribe,
    required String subject,
    required String snippet,
    required bool hasCalendar,
    required bool isVip,
    required bool isUnread,
  });
}
