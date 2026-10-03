# scaffold_features_p3.ps1
# Feature 5: VIP, Feature 6: Compose, Feature 7: Notifications, Feature 8: Settings

function Write-DartFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  Set-Content -Path $path -Value $content.Trim() -Encoding UTF8
}

Write-Output "Scaffolding Feature 5: VIP Senders..."
# 5. VIP Domain
Write-DartFile "lib/features/vip/domain/entities/vip_sender.dart" @"
import 'package:equatable/equatable.dart';

class VipSender extends Equatable {
  final String email;
  final String displayName;
  final bool isMuted;

  const VipSender({
    required this.email,
    required this.displayName,
    this.isMuted = false,
  });

  @override
  List<Object?> get props => [email, displayName, isMuted];
}
"@

Write-DartFile "lib/features/vip/domain/entities/vip_folder.dart" @"
import 'package:equatable/equatable.dart';
import 'vip_sender.dart';

class VipFolder extends Equatable {
  final String id;
  final String name;
  final VipSender sender;

  const VipFolder({
    required this.id,
    required this.name,
    required this.sender,
  });

  @override
  List<Object?> get props => [id, name, sender];
}
"@

Write-DartFile "lib/features/vip/domain/repositories/vip_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/vip_sender.dart';

abstract class VipRepository {
  Future<Either<Failure, List<VipSender>>> getVipSenders();
  Future<Either<Failure, void>> addVipSender(VipSender sender);
  Future<Either<Failure, void>> removeVipSender(String email);
  Future<Either<Failure, void>> toggleVipMute(String email, bool isMuted);
}
"@

Write-DartFile "lib/features/vip/domain/usecases/get_vip_senders.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vip_sender.dart';
import '../repositories/vip_repository.dart';

class GetVipSenders implements UseCase<List<VipSender>, NoParams> {
  final VipRepository repository;
  const GetVipSenders(this.repository);

  @override
  Future<Either<Failure, List<VipSender>>> call(NoParams params) {
    return repository.getVipSenders();
  }
}
"@

Write-DartFile "lib/features/vip/domain/usecases/add_vip_sender.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/vip_sender.dart';
import '../repositories/vip_repository.dart';

class AddVipSender implements UseCase<void, VipSender> {
  final VipRepository repository;
  const AddVipSender(this.repository);

  @override
  Future<Either<Failure, void>> call(VipSender params) {
    return repository.addVipSender(params);
  }
}
"@

Write-DartFile "lib/features/vip/domain/usecases/remove_vip_sender.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/vip_repository.dart';

class RemoveVipSender implements UseCase<void, String> {
  final VipRepository repository;
  const RemoveVipSender(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) {
    return repository.removeVipSender(email);
  }
}
"@

Write-DartFile "lib/features/vip/domain/usecases/toggle_vip_mute.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/vip_repository.dart';

class ToggleVipMuteParams {
  final String email;
  final bool isMuted;
  const ToggleVipMuteParams({required this.email, required this.isMuted});
}

class ToggleVipMute implements UseCase<void, ToggleVipMuteParams> {
  final VipRepository repository;
  const ToggleVipMute(this.repository);

  @override
  Future<Either<Failure, void>> call(ToggleVipMuteParams params) {
    return repository.toggleVipMute(params.email, params.isMuted);
  }
}
"@

# 5. VIP Data
Write-DartFile "lib/features/vip/data/models/vip_sender_model.dart" @"
import '../../domain/entities/vip_sender.dart';

class VipSenderModel extends VipSender {
  const VipSenderModel({
    required super.email,
    required super.displayName,
    super.isMuted,
  });

  factory VipSenderModel.fromJson(Map<String, dynamic> json) {
    return VipSenderModel(
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      isMuted: json['isMuted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'displayName': displayName,
    'isMuted': isMuted,
  };
}
"@

Write-DartFile "lib/features/vip/data/datasources/vip_local_data_source.dart" @"
import '../models/vip_sender_model.dart';

abstract class VipLocalDataSource {
  Future<List<VipSenderModel>> getVipSenders();
  Future<void> insertVipSender(VipSenderModel sender);
  Future<void> deleteVipSender(String email);
  Future<void> updateMuteStatus(String email, bool isMuted);
}
"@

Write-DartFile "lib/features/vip/data/repositories/vip_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/vip_sender.dart';
import '../../domain/repositories/vip_repository.dart';
import '../datasources/vip_local_data_source.dart';
import '../models/vip_sender_model.dart';

class VipRepositoryImpl implements VipRepository {
  final VipLocalDataSource localDataSource;
  const VipRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<VipSender>>> getVipSenders() async {
    try {
      final list = await localDataSource.getVipSenders();
      return Right(list);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addVipSender(VipSender sender) async {
    try {
      await localDataSource.insertVipSender(VipSenderModel(
        email: sender.email,
        displayName: sender.displayName,
        isMuted: sender.isMuted,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeVipSender(String email) async {
    try {
      await localDataSource.deleteVipSender(email);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleVipMute(String email, bool isMuted) async {
    try {
      await localDataSource.updateMuteStatus(email, isMuted);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
"@

# 5. VIP Presentation
Write-DartFile "lib/features/vip/presentation/cubit/vip_state.dart" @"
import 'package:equatable/equatable.dart';
import '../../domain/entities/vip_sender.dart';

abstract class VipState extends Equatable {
  const VipState();
  @override
  List<Object?> get props => [];
}

class VipInitial extends VipState {}
class VipLoading extends VipState {}
class VipLoaded extends VipState {
  final List<VipSender> senders;
  const VipLoaded(this.senders);
  @override
  List<Object?> get props => [senders];
}
class VipError extends VipState {
  final String message;
  const VipError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/vip/presentation/cubit/vip_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/vip_sender.dart';
import '../../domain/usecases/add_vip_sender.dart';
import '../../domain/usecases/get_vip_senders.dart';
import '../../domain/usecases/remove_vip_sender.dart';
import '../../domain/usecases/toggle_vip_mute.dart';
import 'vip_state.dart';

class VipCubit extends Cubit<VipState> {
  final GetVipSenders getVipsUseCase;
  final AddVipSender addVipUseCase;
  final RemoveVipSender removeVipUseCase;
  final ToggleVipMute toggleMuteUseCase;

  VipCubit({
    required this.getVipsUseCase,
    required this.addVipUseCase,
    required this.removeVipUseCase,
    required this.toggleMuteUseCase,
  }) : super(VipInitial());

  Future<void> loadVips() async {
    emit(VipLoading());
    final result = await getVipsUseCase(const NoParams());
    result.fold(
      (f) => emit(VipError(f.message)),
      (senders) => emit(VipLoaded(senders)),
    );
  }

  Future<void> addVip(VipSender sender) async {
    final result = await addVipUseCase(sender);
    result.fold(
      (f) => emit(VipError(f.message)),
      (_) => loadVips(),
    );
  }

  Future<void> removeVip(String email) async {
    final result = await removeVipUseCase(email);
    result.fold(
      (f) => emit(VipError(f.message)),
      (_) => loadVips(),
    );
  }

  Future<void> toggleMute(String email, bool isMuted) async {
    await toggleMuteUseCase(ToggleVipMuteParams(email: email, isMuted: isMuted));
    loadVips();
  }
}
"@

Write-DartFile "lib/features/vip/presentation/pages/vip_folders_page.dart" @"
import 'package:flutter/material.dart';

class VipFoldersPage extends StatelessWidget {
  const VipFoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VIP Folders')),
      body: const Center(child: Text('VIP Folders List')),
    );
  }
}
"@

Write-DartFile "lib/features/vip/presentation/widgets/vip_folder_tile.dart" @"
import 'package:flutter/material.dart';

class VipFolderTile extends StatelessWidget {
  final String senderName;
  final VoidCallback onTap;

  const VipFolderTile({super.key, required this.senderName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.star, color: Colors.amber),
      title: Text(senderName),
      onTap: onTap,
    );
  }
}
"@

Write-DartFile "lib/features/vip/presentation/widgets/add_vip_dialog.dart" @"
import 'package:flutter/material.dart';

class AddVipDialog extends StatelessWidget {
  const AddVipDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add VIP Sender'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      ],
    );
  }
}
"@

Write-Output "Scaffolding Feature 6: Compose (Action Center)..."
# 6. Compose Domain
Write-DartFile "lib/features/compose/domain/entities/draft_email.dart" @"
import 'package:equatable/equatable.dart';

class DraftEmail extends Equatable {
  final String id;
  final String to;
  final String? cc;
  final String? bcc;
  final String subject;
  final String body;
  final DateTime updatedAt;

  const DraftEmail({
    required this.id,
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    required this.body,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, to, cc, bcc, subject, body, updatedAt];
}
"@

Write-DartFile "lib/features/compose/domain/entities/scheduled_email.dart" @"
import 'package:equatable/equatable.dart';

enum ScheduledStatus { pending, sending, sent, failed }

class ScheduledEmail extends Equatable {
  final String id;
  final String to;
  final String subject;
  final String body;
  final DateTime scheduledAt;
  final ScheduledStatus status;

  const ScheduledEmail({
    required this.id,
    required this.to,
    required this.subject,
    required this.body,
    required this.scheduledAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, to, subject, body, scheduledAt, status];
}
"@

Write-DartFile "lib/features/compose/domain/repositories/mail_sender_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/draft_email.dart';
import '../entities/scheduled_email.dart';

abstract class MailSenderRepository {
  Future<Either<Failure, void>> sendEmail({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  });
  Future<Either<Failure, void>> saveDraft(DraftEmail draft);
  Future<Either<Failure, void>> scheduleEmail(ScheduledEmail email);
  Future<Either<Failure, void>> cancelScheduledEmail(String id);
}
"@

Write-DartFile "lib/features/compose/domain/usecases/send_email.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_sender_repository.dart';

class SendEmailParams {
  final String to;
  final String? cc;
  final String? bcc;
  final String subject;
  final String body;

  const SendEmailParams({
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    required this.body,
  });
}

class SendEmail implements UseCase<void, SendEmailParams> {
  final MailSenderRepository repository;
  const SendEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(SendEmailParams params) {
    return repository.sendEmail(
      to: params.to,
      cc: params.cc,
      bcc: params.bcc,
      subject: params.subject,
      body: params.body,
    );
  }
}
"@

Write-DartFile "lib/features/compose/domain/usecases/save_draft.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/draft_email.dart';
import '../repositories/mail_sender_repository.dart';

class SaveDraft implements UseCase<void, DraftEmail> {
  final MailSenderRepository repository;
  const SaveDraft(this.repository);

  @override
  Future<Either<Failure, void>> call(DraftEmail params) {
    return repository.saveDraft(params);
  }
}
"@

Write-DartFile "lib/features/compose/domain/usecases/schedule_email.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/scheduled_email.dart';
import '../repositories/mail_sender_repository.dart';

class ScheduleEmail implements UseCase<void, ScheduledEmail> {
  final MailSenderRepository repository;
  const ScheduleEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(ScheduledEmail params) {
    return repository.scheduleEmail(params);
  }
}
"@

Write-DartFile "lib/features/compose/domain/usecases/cancel_scheduled_email.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/mail_sender_repository.dart';

class CancelScheduledEmail implements UseCase<void, String> {
  final MailSenderRepository repository;
  const CancelScheduledEmail(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) {
    return repository.cancelScheduledEmail(id);
  }
}
"@

# 6. Compose Data
Write-DartFile "lib/features/compose/data/models/draft_email_model.dart" @"
import '../../domain/entities/draft_email.dart';

class DraftEmailModel extends DraftEmail {
  const DraftEmailModel({
    required super.id,
    required super.to,
    super.cc,
    super.bcc,
    required super.subject,
    required super.body,
    required super.updatedAt,
  });
}
"@

Write-DartFile "lib/features/compose/data/models/scheduled_email_model.dart" @"
import '../../domain/entities/scheduled_email.dart';

class ScheduledEmailModel extends ScheduledEmail {
  const ScheduledEmailModel({
    required super.id,
    required super.to,
    required super.subject,
    required super.body,
    required super.scheduledAt,
    required super.status,
  });
}
"@

Write-DartFile "lib/features/compose/data/datasources/compose_remote_data_source.dart" @"
abstract class ComposeRemoteDataSource {
  Future<void> sendRawEmail({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  });
}
"@

Write-DartFile "lib/features/compose/data/datasources/compose_local_data_source.dart" @"
import '../models/draft_email_model.dart';
import '../models/scheduled_email_model.dart';

abstract class ComposeLocalDataSource {
  Future<void> saveDraft(DraftEmailModel draft);
  Future<void> queueScheduledEmail(ScheduledEmailModel email);
  Future<void> removeScheduledEmail(String id);
}
"@

Write-DartFile "lib/features/compose/data/repositories/mail_sender_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/draft_email.dart';
import '../../domain/entities/scheduled_email.dart';
import '../../domain/repositories/mail_sender_repository.dart';
import '../datasources/compose_local_data_source.dart';
import '../datasources/compose_remote_data_source.dart';
import '../models/draft_email_model.dart';
import '../models/scheduled_email_model.dart';

class MailSenderRepositoryImpl implements MailSenderRepository {
  final ComposeRemoteDataSource remoteDataSource;
  final ComposeLocalDataSource localDataSource;

  const MailSenderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> sendEmail({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  }) async {
    try {
      await remoteDataSource.sendRawEmail(to: to, cc: cc, bcc: bcc, subject: subject, body: body);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDraft(DraftEmail draft) async {
    try {
      await localDataSource.saveDraft(DraftEmailModel(
        id: draft.id,
        to: draft.to,
        cc: draft.cc,
        bcc: draft.bcc,
        subject: draft.subject,
        body: draft.body,
        updatedAt: draft.updatedAt,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> scheduleEmail(ScheduledEmail email) async {
    try {
      await localDataSource.queueScheduledEmail(ScheduledEmailModel(
        id: email.id,
        to: email.to,
        subject: email.subject,
        body: email.body,
        scheduledAt: email.scheduledAt,
        status: email.status,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelScheduledEmail(String id) async {
    try {
      await localDataSource.removeScheduledEmail(id);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
"@

# 6. Compose Presentation
Write-DartFile "lib/features/compose/presentation/cubit/compose_state.dart" @"
import 'package:equatable/equatable.dart';

abstract class ComposeState extends Equatable {
  const ComposeState();
  @override
  List<Object?> get props => [];
}

class ComposeInitial extends ComposeState {}
class ComposeSending extends ComposeState {}
class ComposeSent extends ComposeState {}
class ComposeDraftSaved extends ComposeState {}
class ComposeScheduled extends ComposeState {}
class ComposeError extends ComposeState {
  final String message;
  const ComposeError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/compose/presentation/cubit/compose_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/draft_email.dart';
import '../../domain/entities/scheduled_email.dart';
import '../../domain/usecases/save_draft.dart';
import '../../domain/usecases/schedule_email.dart';
import '../../domain/usecases/send_email.dart';
import 'compose_state.dart';

class ComposeCubit extends Cubit<ComposeState> {
  final SendEmail sendEmailUseCase;
  final SaveDraft saveDraftUseCase;
  final ScheduleEmail scheduleEmailUseCase;

  ComposeCubit({
    required this.sendEmailUseCase,
    required this.saveDraftUseCase,
    required this.scheduleEmailUseCase,
  }) : super(ComposeInitial());

  Future<void> send({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  }) async {
    emit(ComposeSending());
    final result = await sendEmailUseCase(SendEmailParams(
      to: to,
      cc: cc,
      bcc: bcc,
      subject: subject,
      body: body,
    ));
    result.fold(
      (f) => emit(ComposeError(f.message)),
      (_) => emit(ComposeSent()),
    );
  }

  Future<void> save(DraftEmail draft) async {
    final result = await saveDraftUseCase(draft);
    result.fold(
      (f) => emit(ComposeError(f.message)),
      (_) => emit(ComposeDraftSaved()),
    );
  }

  Future<void> schedule(ScheduledEmail email) async {
    final result = await scheduleEmailUseCase(email);
    result.fold(
      (f) => emit(ComposeError(f.message)),
      (_) => emit(ComposeScheduled()),
    );
  }
}
"@

Write-DartFile "lib/features/compose/presentation/pages/compose_page.dart" @"
import 'package:flutter/material.dart';

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compose')),
      body: const Center(child: Text('Email Compose View')),
    );
  }
}
"@

Write-DartFile "lib/features/compose/presentation/widgets/directional_text_field.dart" @"
import 'package:flutter/material.dart';

class DirectionalTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;

  const DirectionalTextField({super.key, required this.label, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
"@

Write-DartFile "lib/features/compose/presentation/widgets/schedule_time_picker.dart" @"
import 'package:flutter/material.dart';

class ScheduleTimePicker extends StatelessWidget {
  const ScheduleTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Pick Send Time'),
    );
  }
}
"@

Write-DartFile "lib/features/compose/presentation/widgets/attachment_tray.dart" @"
import 'package:flutter/material.dart';

class AttachmentTray extends StatelessWidget {
  const AttachmentTray({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [Icon(Icons.attach_file)]);
  }
}
"@

Write-Output "Scaffolding Feature 7: Notifications..."
# 7. Notifications Domain
Write-DartFile "lib/features/notifications/domain/entities/zen_notification_policy.dart" @"
import 'package:equatable/equatable.dart';

class ZenNotificationPolicy extends Equatable {
  final bool quietHoursEnabled;
  final int quietHoursStartMinutes;
  final int quietHoursEndMinutes;

  const ZenNotificationPolicy({
    required this.quietHoursEnabled,
    required this.quietHoursStartMinutes,
    required this.quietHoursEndMinutes,
  });

  @override
  List<Object?> get props => [quietHoursEnabled, quietHoursStartMinutes, quietHoursEndMinutes];
}
"@

Write-DartFile "lib/features/notifications/domain/repositories/notification_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../categorization/domain/entities/mail_bucket.dart';

abstract class NotificationRepository {
  Future<Either<Failure, bool>> shouldNotify({
    required bool isVip,
    required MailBucket bucket,
    required DateTime receivedAt,
  });
  Future<Either<Failure, void>> showNotification({
    required String title,
    required String body,
    required String messageId,
  });
}
"@

Write-DartFile "lib/features/notifications/domain/usecases/should_notify_for_email.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../repositories/notification_repository.dart';

class ShouldNotifyParams {
  final bool isVip;
  final MailBucket bucket;
  final DateTime receivedAt;

  const ShouldNotifyParams({
    required this.isVip,
    required this.bucket,
    required this.receivedAt,
  });
}

class ShouldNotifyForEmail implements UseCase<bool, ShouldNotifyParams> {
  final NotificationRepository repository;
  const ShouldNotifyForEmail(this.repository);

  @override
  Future<Either<Failure, bool>> call(ShouldNotifyParams params) {
    return repository.shouldNotify(
      isVip: params.isVip,
      bucket: params.bucket,
      receivedAt: params.receivedAt,
    );
  }
}
"@

Write-DartFile "lib/features/notifications/domain/usecases/show_local_notification.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/notification_repository.dart';

class ShowNotificationParams {
  final String title;
  final String body;
  final String messageId;

  const ShowNotificationParams({
    required this.title,
    required this.body,
    required this.messageId,
  });
}

class ShowLocalNotification implements UseCase<void, ShowNotificationParams> {
  final NotificationRepository repository;
  const ShowLocalNotification(this.repository);

  @override
  Future<Either<Failure, void>> call(ShowNotificationParams params) {
    return repository.showNotification(
      title: params.title,
      body: params.body,
      messageId: params.messageId,
    );
  }
}
"@

# 7. Notifications Data
Write-DartFile "lib/features/notifications/data/datasources/fcm_remote_data_source.dart" @"
abstract class FcmRemoteDataSource {
  Future<String?> getFcmToken();
}
"@

Write-DartFile "lib/features/notifications/data/datasources/local_notification_data_source.dart" @"
abstract class LocalNotificationDataSource {
  Future<void> displayNotification({
    required String title,
    required String body,
    required String messageId,
  });
}
"@

Write-DartFile "lib/features/notifications/data/repositories/notification_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../categorization/domain/entities/mail_bucket.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/local_notification_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final LocalNotificationDataSource localDataSource;

  const NotificationRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> shouldNotify({
    required bool isVip,
    required MailBucket bucket,
    required DateTime receivedAt,
  }) async {
    // Zen notification rule: push ONLY for VIP or Important unread
    final eligible = isVip || bucket == MailBucket.importantUnread;
    return Right(eligible);
  }

  @override
  Future<Either<Failure, void>> showNotification({
    required String title,
    required String body,
    required String messageId,
  }) async {
    try {
      await localDataSource.displayNotification(title: title, body: body, messageId: messageId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
"@

# 7. Notifications Presentation
Write-DartFile "lib/features/notifications/presentation/cubit/notification_state.dart" @"
import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoaded extends NotificationState {}
"@

Write-DartFile "lib/features/notifications/presentation/cubit/notification_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());
}
"@

Write-Output "Scaffolding Feature 8: Settings..."
# 8. Settings Domain
Write-DartFile "lib/features/settings/domain/entities/app_settings.dart" @"
import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String locale;
  final String timezone;
  final bool useArabicIndicDigits;
  final bool quietHoursEnabled;

  const AppSettings({
    required this.locale,
    required this.timezone,
    this.useArabicIndicDigits = false,
    this.quietHoursEnabled = false,
  });

  @override
  List<Object?> get props => [locale, timezone, useArabicIndicDigits, quietHoursEnabled];
}
"@

Write-DartFile "lib/features/settings/domain/repositories/settings_repository.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, AppSettings>> getSettings();
  Future<Either<Failure, void>> updateSettings(AppSettings settings);
}
"@

Write-DartFile "lib/features/settings/domain/usecases/get_app_settings.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetAppSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;
  const GetAppSettings(this.repository);

  @override
  Future<Either<Failure, AppSettings>> call(NoParams params) {
    return repository.getSettings();
  }
}
"@

Write-DartFile "lib/features/settings/domain/usecases/update_app_settings.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class UpdateAppSettings implements UseCase<void, AppSettings> {
  final SettingsRepository repository;
  const UpdateAppSettings(this.repository);

  @override
  Future<Either<Failure, void>> call(AppSettings params) {
    return repository.updateSettings(params);
  }
}
"@

# 8. Settings Data
Write-DartFile "lib/features/settings/data/models/app_settings_model.dart" @"
import '../../domain/entities/app_settings.dart';

class AppSettingsModel extends AppSettings {
  const AppSettingsModel({
    required super.locale,
    required super.timezone,
    super.useArabicIndicDigits,
    super.quietHoursEnabled,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      locale: json['locale'] as String,
      timezone: json['timezone'] as String,
      useArabicIndicDigits: json['useArabicIndicDigits'] as bool? ?? false,
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'locale': locale,
    'timezone': timezone,
    'useArabicIndicDigits': useArabicIndicDigits,
    'quietHoursEnabled': quietHoursEnabled,
  };
}
"@

Write-DartFile "lib/features/settings/data/datasources/settings_local_data_source.dart" @"
import '../models/app_settings_model.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettingsModel> loadSettings();
  Future<void> persistSettings(AppSettingsModel settings);
}
"@

Write-DartFile "lib/features/settings/data/repositories/settings_repository_impl.dart" @"
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;
  const SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final settings = await localDataSource.loadSettings();
      return Right(settings);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      await localDataSource.persistSettings(AppSettingsModel(
        locale: settings.locale,
        timezone: settings.timezone,
        useArabicIndicDigits: settings.useArabicIndicDigits,
        quietHoursEnabled: settings.quietHoursEnabled,
      ));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
"@

# 8. Settings Presentation
Write-DartFile "lib/features/settings/presentation/cubit/settings_state.dart" @"
import 'package:equatable/equatable.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}
class SettingsLoading extends SettingsState {}
class SettingsLoaded extends SettingsState {
  final AppSettings settings;
  const SettingsLoaded(this.settings);
  @override
  List<Object?> get props => [settings];
}
class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override
  List<Object?> get props => [message];
}
"@

Write-DartFile "lib/features/settings/presentation/cubit/settings_cubit.dart" @"
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_app_settings.dart';
import '../../domain/usecases/update_app_settings.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetAppSettings getSettingsUseCase;
  final UpdateAppSettings updateSettingsUseCase;

  SettingsCubit({
    required this.getSettingsUseCase,
    required this.updateSettingsUseCase,
  }) : super(SettingsInitial());

  Future<void> loadSettings() async {
    emit(SettingsLoading());
    final result = await getSettingsUseCase(const NoParams());
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> saveSettings(AppSettings settings) async {
    final result = await updateSettingsUseCase(settings);
    result.fold(
      (f) => emit(SettingsError(f.message)),
      (_) => emit(SettingsLoaded(settings)),
    );
  }
}
"@

Write-DartFile "lib/features/settings/presentation/pages/settings_page.dart" @"
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('App Settings')),
    );
  }
}
"@

Write-DartFile "lib/features/settings/presentation/widgets/locale_selector.dart" @"
import 'package:flutter/material.dart';

class LocaleSelector extends StatelessWidget {
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(title: Text('Language / اللغة'));
  }
}
"@

Write-DartFile "lib/features/settings/presentation/widgets/quiet_hours_tile.dart" @"
import 'package:flutter/material.dart';

class QuietHoursTile extends StatelessWidget {
  const QuietHoursTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const SwitchListTile(value: false, onChanged: null, title: Text('Quiet Hours'));
  }
}
"@

Write-Output "VIP, Compose, Notifications, and Settings scaffolded."
