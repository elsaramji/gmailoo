# scaffold_features_p2.ps1
# Feature 3: Mailbox & Feature 4: Categorization

function Write-DartFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  Set-Content -Path $path -Value $content.Trim() -Encoding UTF8
}

Write-Output "Scaffolding Feature 3: Mailbox..."
# 3. Mailbox Domain
Write-DartFile "lib/features/mailbox/domain/entities/attachment.dart" @"
import 'package:equatable/equatable.dart';

class Attachment extends Equatable {
  final String id;
  final String filename;
  final String mimeType;
  final int sizeBytes;

  const Attachment({
    required this.id,
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
  });

  @override
  List<Object?> get props => [id, filename, mimeType, sizeBytes];
}
"@

Write-DartFile "lib/features/mailbox/domain/entities/email_body.dart" @"
import 'package:equatable/equatable.dart';

class EmailBody extends Equatable {
  final String messageId;
  final String? textPlain;
  final String? textHtml;

  const EmailBody({
    required this.messageId,
    this.textPlain,
    this.textHtml,
  });

  @override
  List<Object?> get props => [messageId, textPlain, textHtml];
}
"@

Write-DartFile "lib/features/mailbox/domain/entities/email.dart" @"
import 'package:equatable/equatable.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import 'attachment.dart';

class Email extends Equatable {
  final String id;
  final String threadId;
  final String from;
  final String to;
  final String subject;
  final String snippet;
  final DateTime receivedAt;
  final bool isUnread;
  final MailBucket bucket;
  final List<Attachment> attachments;

  const Email({
    required this.id,
    required this.threadId,
    required this.from,
    required this.to,
    required this.subject,
    required this.snippet,
    required this.receivedAt,
    required this.isUnread,
    required this.bucket,
    required this.attachments,
  });

  @override
  List<Object?> get props => [id, threadId, from, to, subject, snippet, receivedAt, isUnread, bucket, attachments];
}
"@

Write-DartFile "lib/features/mailbox/domain/repositories/mail_reader_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../entities/email.dart';
import '../entities/email_body.dart';

abstract class MailReaderRepository {
  Future<Either<Failure, List<Email>>> syncCycleEmails();
  Future<Either<Failure, List<Email>>> getEmailsByBucket(MailBucket bucket);
  Future<Either<Failure, EmailBody>> getEmailBody(String messageId);
  Future<Either<Failure, void>> markAsRead(String messageId);
}
"@

Write-DartFile "lib/features/mailbox/domain/usecases/sync_current_cycle_emails.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email.dart';
import '../repositories/mail_reader_repository.dart';

class SyncCurrentCycleEmails implements UseCase<List<Email>, NoParams> {
  final MailReaderRepository repository;
  const SyncCurrentCycleEmails(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(NoParams params) {
    return repository.syncCycleEmails();
  }
}
"@

Write-DartFile "lib/features/mailbox/domain/usecases/get_emails_by_bucket.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../entities/email.dart';
import '../repositories/mail_reader_repository.dart';

class GetEmailsByBucket implements UseCase<List<Email>, MailBucket> {
  final MailReaderRepository repository;
  const GetEmailsByBucket(this.repository);

  @override
  Future<Either<Failure, List<Email>>> call(MailBucket bucket) {
    return repository.getEmailByBucket(bucket);
  }
}
"@

Write-DartFile "lib/features/mailbox/domain/usecases/get_email_body.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/email_body.dart';
import '../repositories/mail_reader_repository.dart';

class GetEmailBody implements UseCase<EmailBody, String> {
  final MailReaderRepository repository;
  const GetEmailBody(this.repository);

  @override
  Future<Either<Failure, EmailBody>> call(String messageId) {
    return repository.getEmailBody(messageId);
  }
}
"@

Write-DartFile "lib/features/mailbox/domain/usecases/mark_email_as_read.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_reader_repository.dart';

class MarkEmailAsRead implements UseCase<void, String> {
  final MailReaderRepository repository;
  const MarkEmailAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(String messageId) {
    return repository.markAsRead(messageId);
  }
}
"@

# 3. Mailbox Data
Write-DartFile "lib/features/mailbox/data/models/attachment_model.dart" @"
import '../../domain/entities/attachment.dart';

class AttachmentModel extends Attachment {
  const AttachmentModel({
    required super.id,
    required super.filename,
    required super.mimeType,
    required super.sizeBytes,
  });
}
"@

Write-DartFile "lib/features/mailbox/data/models/email_body_model.dart" @"
import '../../domain/entities/email_body.dart';

class EmailBodyModel extends EmailBody {
  const EmailBodyModel({
    required super.messageId,
    super.textPlain,
    super.textHtml,
  });
}
"@

Write-DartFile "lib/features/mailbox/data/models/email_model.dart" @"
import '../../domain/entities/email.dart';

class EmailModel extends Email {
  const EmailModel({
    required super.id,
    required super.threadId,
    required super.from,
    required super.to,
    required super.subject,
    required super.snippet,
    required super.receivedAt,
    required super.isUnread,
    required super.bucket,
    required super.attachments,
  });
}
"@

Write-DartFile "lib/features/mailbox/data/datasources/gmail_remote_data_source.dart" @"
import '../models/email_body_model.dart';
import '../models/email_model.dart';

abstract class GmailRemoteDataSource {
  Future<List<EmailModel>> fetchCycleEmails({required int afterEpoch, required int beforeEpoch});
  Future<EmailBodyModel> fetchEmailBody(String messageId);
  Future<void> markAsRead(String messageId);
}
"@

Write-DartFile "lib/features/mailbox/data/datasources/mail_local_data_source.dart" @"
import '../../categorization/domain/entities/mail_bucket.dart';
import '../models/email_body_model.dart';
import '../models/email_model.dart';

abstract class MailLocalDataSource {
  Future<List<EmailModel>> getCachedEmails(MailBucket bucket);
  Future<void> cacheEmails(List<EmailModel> emails);
  Future<EmailBodyModel?> getCachedBody(String messageId);
  Future<void> cacheBody(EmailBodyModel body);
  Future<void> updateReadStatus(String messageId, bool isRead);
}
"@

Write-DartFile "lib/features/mailbox/data/repositories/mail_reader_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../../domain/entities/email.dart';
import '../../domain/entities/email_body.dart';
import '../../domain/repositories/mail_reader_repository.dart';
import '../datasources/gmail_remote_data_source.dart';
import '../datasources/mail_local_data_source.dart';

class MailReaderRepositoryImpl implements MailReaderRepository {
  final GmailRemoteDataSource remoteDataSource;
  final MailLocalDataSource localDataSource;

  const MailReaderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Email>>> syncCycleEmails() async {
    try {
      final emails = await remoteDataSource.fetchCycleEmails(afterEpoch: 0, beforeEpoch: 0);
      await localDataSource.cacheEmails(emails);
      return Right(emails);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Email>>> getEmailsByBucket(MailBucket bucket) async {
    try {
      final cached = await localDataSource.getCachedEmails(bucket);
      return Right(cached);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmailBody>> getEmailBody(String messageId) async {
    try {
      final cached = await localDataSource.getCachedBody(messageId);
      if (cached != null) return Right(cached);
      final body = await remoteDataSource.fetchEmailBody(messageId);
      await localDataSource.cacheBody(body);
      return Right(body);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String messageId) async {
    try {
      await localDataSource.updateReadStatus(messageId, true);
      await remoteDataSource.markAsRead(messageId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
"@

# 3. Mailbox Presentation
Write-DartFile "lib/features/mailbox/presentation/cubit/mailbox_state.dart" @"
import 'package:equatable/equatable.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../../domain/entities/email.dart';

abstract class MailboxState extends Equatable {
  const MailboxState();
  @override
  List<Object?> get props => [];
}

class MailboxInitial extends MailboxState {}
class MailboxLoading extends MailboxState {}
class MailboxLoaded extends MailboxState {
  final List<Email> emails;
  final MailBucket selectedBucket;
  const MailboxLoaded({required this.emails, required this.selectedBucket});
  @override
  List<Object?> get props => [emails, selectedBucket];
}
class MailboxError extends MailboxState {
  final String message;
  const MailboxError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/mailbox/presentation/cubit/mailbox_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../../domain/usecases/get_emails_by_bucket.dart';
import '../../domain/usecases/sync_current_cycle_emails.dart';
import 'mailbox_state.dart';

class MailboxCubit extends Cubit<MailboxState> {
  final SyncCurrentCycleEmails syncUseCase;
  final GetEmailsByBucket getEmailsUseCase;

  MailboxCubit({
    required this.syncUseCase,
    required this.getEmailsUseCase,
  }) : super(MailboxInitial());

  Future<void> sync() async {
    emit(MailboxLoading());
    final result = await syncUseCase(const NoParams());
    result.fold(
      (f) => emit(MailboxError(f.message)),
      (emails) => emit(MailboxLoaded(emails: emails, selectedBucket: MailBucket.importantUnread)),
    );
  }

  Future<void> changeBucket(MailBucket bucket) async {
    emit(MailboxLoading());
    final result = await getEmailsUseCase(bucket);
    result.fold(
      (f) => emit(MailboxError(f.message)),
      (emails) => emit(MailboxLoaded(emails: emails, selectedBucket: bucket)),
    );
  }
}
"@

Write-DartFile "lib/features/mailbox/presentation/pages/mailbox_page.dart" @"
import 'package:flutter/material.dart';

class MailboxPage extends StatelessWidget {
  const MailboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Gmailoo Mailbox'),
      ),
    );
  }
}
"@

Write-DartFile "lib/features/mailbox/presentation/pages/email_detail_page.dart" @"
import 'package:flutter/material.dart';

class EmailDetailPage extends StatelessWidget {
  final String messageId;
  const EmailDetailPage({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Detail')),
      body: Center(child: Text('Message: \$messageId')),
    );
  }
}
"@

Write-DartFile "lib/features/mailbox/presentation/widgets/email_card.dart" @"
import 'package:flutter/material.dart';

class EmailCard extends StatelessWidget {
  final String subject;
  final String from;
  final VoidCallback onTap;

  const EmailCard({
    super.key,
    required this.subject,
    required this.from,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subject),
      subtitle: Text(from),
      onTap: onTap,
    );
  }
}
"@

Write-DartFile "lib/features/mailbox/presentation/widgets/bucket_filter_bar.dart" @"
import 'package:flutter/material.dart';

class BucketFilterBar extends StatelessWidget {
  const BucketFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Chip(label: Text('All')),
      ],
    );
  }
}
"@

Write-DartFile "lib/features/mailbox/presentation/widgets/open_in_gmail_button.dart" @"
import 'package:flutter/material.dart';

class OpenInGmailButton extends StatelessWidget {
  final String messageId;
  const OpenInGmailButton({super.key, required this.messageId});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text('Open in Gmail'),
    );
  }
}
"@

Write-Output "Scaffolding Feature 4: Categorization..."
# 4. Categorization Domain
Write-DartFile "lib/features/categorization/domain/entities/mail_bucket.dart" @"
enum MailBucket {
  marketing,
  timetables,
  importantUnread,
  important,
  other,
}
"@

Write-DartFile "lib/features/categorization/domain/entities/sender_override.dart" @"
import 'package:equatable/equatable.dart';
import 'mail_bucket.dart';

class SenderOverride extends Equatable {
  final String senderAddress;
  final MailBucket forcedBucket;

  const SenderOverride({
    required this.senderAddress,
    required this.forcedBucket,
  });

  @override
  List<Object?> get props => [senderAddress, forcedBucket];
}
"@

Write-DartFile "lib/features/categorization/domain/entities/classification_rule.dart" @"
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
"@

Write-DartFile "lib/features/categorization/domain/repositories/categorization_repository.dart" @"
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
"@

Write-DartFile "lib/features/categorization/domain/usecases/classify_email.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/mail_bucket.dart';
import '../repositories/categorization_repository.dart';

class ClassifyEmailParams {
  final String fromAddress;
  final List<String> labels;
  final String? listUnsubscribe;
  final String subject;
  final String snippet;
  final bool hasCalendar;
  final bool isVip;
  final bool isUnread;

  const ClassifyEmailParams({
    required this.fromAddress,
    required this.labels,
    this.listUnsubscribe,
    required this.subject,
    required this.snippet,
    required this.hasCalendar,
    required this.isVip,
    required this.isUnread,
  });
}

class ClassifyEmail implements UseCase<MailBucket, ClassifyEmailParams> {
  final CategorizationRepository repository;
  const ClassifyEmail(this.repository);

  @override
  Future<Either<Failure, MailBucket>> call(ClassifyEmailParams params) {
    return repository.classifyEmail(
      fromAddress: params.fromAddress,
      labels: params.labels,
      listUnsubscribe: params.listUnsubscribe,
      subject: params.subject,
      snippet: params.snippet,
      hasCalendar: params.hasCalendar,
      isVip: params.isVip,
      isUnread: params.isUnread,
    );
  }
}
"@

Write-DartFile "lib/features/categorization/domain/usecases/set_sender_override.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/sender_override.dart';
import '../repositories/categorization_repository.dart';

class SetSenderOverride implements UseCase<void, SenderOverride> {
  final CategorizationRepository repository;
  const SetSenderOverride(this.repository);

  @override
  Future<Either<Failure, void>> call(SenderOverride params) {
    return repository.setSenderOverride(params);
  }
}
"@

# 4. Categorization Data
Write-DartFile "lib/features/categorization/data/models/sender_override_model.dart" @"
import '../../domain/entities/mail_bucket.dart';
import '../../domain/entities/sender_override.dart';

class SenderOverrideModel extends SenderOverride {
  const SenderOverrideModel({
    required super.senderAddress,
    required super.forcedBucket,
  });

  factory SenderOverrideModel.fromJson(Map<String, dynamic> json) {
    return SenderOverrideModel(
      senderAddress: json['senderAddress'] as String,
      forcedBucket: MailBucket.values.firstWhere((e) => e.name == json['forcedBucket']),
    );
  }

  Map<String, dynamic> toJson() => {
    'senderAddress': senderAddress,
    'forcedBucket': forcedBucket.name,
  };
}
"@

Write-DartFile "lib/features/categorization/data/rules/marketing_classification_rule.dart" @"
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
"@

Write-DartFile "lib/features/categorization/data/rules/timetable_classification_rule.dart" @"
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
    final content = '\$subject \$snippet'.toLowerCase();
    for (final kw in keywords) {
      if (content.contains(kw)) return MailBucket.timetables;
    }
    return null;
  }
}
"@

Write-DartFile "lib/features/categorization/data/rules/important_classification_rule.dart" @"
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
"@

Write-DartFile "lib/features/categorization/data/rules/fallback_classification_rule.dart" @"
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
"@

Write-DartFile "lib/features/categorization/data/datasources/categorization_local_data_source.dart" @"
import '../models/sender_override_model.dart';

abstract class CategorizationLocalDataSource {
  Future<SenderOverrideModel?> getOverrideFor(String senderAddress);
  Future<void> saveOverride(SenderOverrideModel override);
  Future<List<SenderOverrideModel>> getAllOverrides();
}
"@

Write-DartFile "lib/features/categorization/data/repositories/categorization_repository_impl.dart" @"
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
"@

# 4. Categorization Presentation
Write-DartFile "lib/features/categorization/presentation/cubit/categorization_state.dart" @"
import 'package:equatable/equatable.dart';

abstract class CategorizationState extends Equatable {
  const CategorizationState();
  @override
  List<Object?> get props => [];
}

class CategorizationInitial extends CategorizationState {}
class CategorizationLoading extends CategorizationState {}
class CategorizationSaved extends CategorizationState {}
class CategorizationError extends CategorizationState {
  final String message;
  const CategorizationError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/categorization/presentation/cubit/categorization_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sender_override.dart';
import '../../domain/usecases/set_sender_override.dart';
import 'categorization_state.dart';

class CategorizationCubit extends Cubit<CategorizationState> {
  final SetSenderOverride setOverrideUseCase;

  CategorizationCubit({required this.setOverrideUseCase}) : super(CategorizationInitial());

  Future<void> saveOverride(SenderOverride override) async {
    emit(CategorizationLoading());
    final result = await setOverrideUseCase(override);
    result.fold(
      (f) => emit(CategorizationError(f.message)),
      (_) => emit(CategorizationSaved()),
    );
  }
}
"@

Write-DartFile "lib/features/categorization/presentation/widgets/move_to_category_sheet.dart" @"
import 'package:flutter/material.dart';
import '../../domain/entities/mail_bucket.dart';

class MoveToCategorySheet extends StatelessWidget {
  final void Function(MailBucket bucket) onSelect;
  const MoveToCategorySheet({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: MailBucket.values.map((b) => ListTile(
        title: Text(b.name),
        onTap: () => onSelect(b),
      )).toList(),
    );
  }
}
"@

Write-DartFile "lib/features/categorization/presentation/widgets/bucket_chip.dart" @"
import 'package:flutter/material.dart';
import '../../domain/entities/mail_bucket.dart';

class BucketChip extends StatelessWidget {
  final MailBucket bucket;
  const BucketChip({super.key, required this.bucket});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(bucket.name));
  }
}
"@

Write-Output "Mailbox and Categorization scaffolded."
