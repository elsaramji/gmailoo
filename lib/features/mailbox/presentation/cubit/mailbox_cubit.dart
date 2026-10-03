import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmailoo/core/usecase/usecase.dart';
import 'package:gmailoo/features/categorization/domain/entities/mail_bucket.dart';
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
