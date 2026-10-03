import '../../domain/entities/classification_rule.dart';
import '../../domain/entities/mail_bucket.dart';

class ImportantClassificationRule implements ClassificationRule {
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
    final isImportant = isVip || labels.contains('IMPORTANT');
    if (isImportant) {
      return isUnread ? MailBucket.importantUnread : MailBucket.important;
    }
    return null;
  }
}
