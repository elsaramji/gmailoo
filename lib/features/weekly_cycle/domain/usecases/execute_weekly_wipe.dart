import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/cycle_repository.dart';

class ExecuteWeeklyWipe implements UseCase<void, NoParams> {
  final CycleRepository repository;
  const ExecuteWeeklyWipe(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.executeWeeklyWipe();
  }
}
