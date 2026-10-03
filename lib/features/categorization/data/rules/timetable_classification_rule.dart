import '../../domain/entities/classification_rule.dart';
import '../../domain/entities/mail_bucket.dart';

class TimetableClassificationRule implements ClassificationRule {
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
    if (hasCalendar) return MailBucket.timetables;
    final keywords = ['timetable', 'schedule', 'lecture', 'exam', 'جدول', 'محاضرة', 'امتحان', 'موعد'];
    final content = '$subject $snippet'.toLowerCase();
    for (final kw in keywords) {
      if (content.contains(kw)) return MailBucket.timetables;
    }
    return null;
  }
}
