import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/mail_bucket.dart';
import '../entities/sender_override.dart';

abstract class CategorizationRepository {
  Future<Either<Failure, MailBucket>> classifyEmail({
    required String fromAddress,
    required List<String> labels,
    required String? listUnsubscribe,
    required String subject,
    required String snippet,
    required bool hasCalendar,
    required bool isVip,
    required bool isUnread,
  });
  Future<Either<Failure, void>> setSenderOverride(SenderOverride override);
  Future<Either<Failure, List<SenderOverride>>> getSenderOverrides();
}
