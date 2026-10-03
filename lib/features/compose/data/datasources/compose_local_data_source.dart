import '../models/draft_email_model.dart';
import '../models/scheduled_email_model.dart';

abstract class ComposeLocalDataSource {
  Future<void> saveDraft(DraftEmailModel draft);
  Future<void> queueScheduledEmail(ScheduledEmailModel email);
  Future<void> removeScheduledEmail(String id);
}
