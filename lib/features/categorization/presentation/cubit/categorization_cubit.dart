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
