import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/execute_weekly_wipe.dart';
import '../../domain/usecases/get_current_cycle_status.dart';
import 'weekly_cycle_state.dart';

class WeeklyCycleCubit extends Cubit<WeeklyCycleState> {
  final GetCurrentCycleStatus getCycleStatusUseCase;
  final ExecuteWeeklyWipe executeWipeUseCase;

  WeeklyCycleCubit({
    required this.getCycleStatusUseCase,
    required this.executeWipeUseCase,
  }) : super(WeeklyCycleInitial());

  Future<void> loadCycleStatus() async {
    emit(WeeklyCycleLoading());
    final result = await getCycleStatusUseCase(const NoParams());
    result.fold(
      (f) => emit(WeeklyCycleError(f.message)),
      (status) => emit(WeeklyCycleLoaded(status)),
    );
  }

  Future<void> wipeCycle() async {
    emit(WeeklyCycleLoading());
    final result = await executeWipeUseCase(const NoParams());
    result.fold(
      (f) => emit(WeeklyCycleError(f.message)),
      (_) => emit(WeeklyCycleWiped()),
    );
  }
}
