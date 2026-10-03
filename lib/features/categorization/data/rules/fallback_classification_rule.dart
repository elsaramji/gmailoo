import '../../domain/entities/classification_rule.dart';
import '../../domain/entities/mail_bucket.dart';

class FallbackClassificationRule implements ClassificationRule {
  @override
  MailBucket? classify({
    required List<String> labels,
    required String? listUnsubscribe,
    required String subject,
    required String snippet,
    required bool hasCalendar,
    required bool isVip,
    required bool isUnread,
  }) {
    return MailBucket.other;
  }
}
