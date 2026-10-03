import '../models/email_body_model.dart';
import '../models/email_model.dart';

abstract class GmailRemoteDataSource {
  Future<List<EmailModel>> fetchCycleEmails({required int afterEpoch, required int beforeEpoch});
  Future<EmailBodyModel> fetchEmailBody(String messageId);
  Future<void> markAsRead(String messageId);
}
