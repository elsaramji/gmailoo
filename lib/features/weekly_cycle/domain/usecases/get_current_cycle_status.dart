import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/cycle_status.dart';
import '../repositories/cycle_repository.dart';

class GetCurrentCycleStatus implements UseCase<CycleStatus, NoParams> {
  final CycleRepository repository;
  const GetCurrentCycleStatus(this.repository);

  @override
  Future<Either<Failure, CycleStatus>> call(NoParams params) {
    return repository.getCurrentCycleStatus();
  }
}
