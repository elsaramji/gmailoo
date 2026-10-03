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
