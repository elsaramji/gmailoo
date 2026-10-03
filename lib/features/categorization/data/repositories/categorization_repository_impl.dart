import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/classification_rule.dart';
import '../../domain/entities/mail_bucket.dart';
import '../../domain/entities/sender_override.dart';
import '../../domain/repositories/categorization_repository.dart';
import '../datasources/categorization_local_data_source.dart';
import '../models/sender_override_model.dart';

class CategorizationRepositoryImpl implements CategorizationRepository {
  final CategorizationLocalDataSource localDataSource;
  final List<ClassificationRule> rulePipeline;

  const CategorizationRepositoryImpl({
    required this.localDataSource,
    required this.rulePipeline,
  });

  @override
  Future<Either<Failure, MailBucket>> classifyEmail({
    required String fromAddress,
    required List<String> labels,
    required String? listUnsubscribe,
    required String subject,
    required String snippet,
    required bool hasCalendar,
    required bool isVip,
    required bool isUnread,
  }) async {
    try {
      final override = await localDataSource.getOverrideFor(fromAddress);
      if (override != null) return Right(override.forcedBucket);

      for (final rule in rulePipeline) {
        final bucket = rule.classify(
          labels: labels,
          listUnsubscribe: listUnsubscribe,
          subject: subject,
          snippet: snippet,
          hasCalendar: hasCalendar,
          isVip: isVip,
          isUnread: isUnread,
        );
        if (bucket != null) return Right(bucket);
      }
      return const Right(MailBucket.other);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setSenderOverride(SenderOverride override) async {
    try {
      await localDataSource.saveOverride(SenderOverrideModel(
        senderAddress: override.senderAddress,
        forcedBucket: override.forcedBucket,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SenderOverride>>> getSenderOverrides() async {
    try {
      final list = await localDataSource.getAllOverrides();
      return Right(list);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
