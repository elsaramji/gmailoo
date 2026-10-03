import '../../domain/entities/classification_rule.dart';
import '../../domain/entities/mail_bucket.dart';

class MarketingClassificationRule implements ClassificationRule {
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
    if (isVip) return null;
    if (labels.contains('CATEGORY_PROMOTIONS') || listUnsubscribe != null) {
      return MailBucket.marketing;
    }
    return null;
  }
}
