import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';

import '../models/email_body_model.dart';
import '../models/email_model.dart';

abstract class MailLocalDataSource {
  Future<List<EmailModel>> getCachedEmails(MailBucket bucket);
  Future<void> cacheEmails(List<EmailModel> emails);
  Future<EmailBodyModel?> getCachedBody(String messageId);
  Future<void> cacheBody(EmailBodyModel body);
  Future<void> updateReadStatus(String messageId, bool isRead);
}
