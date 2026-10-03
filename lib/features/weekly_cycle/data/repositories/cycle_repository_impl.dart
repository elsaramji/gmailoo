import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cycle_status.dart';
import '../../domain/repositories/cycle_repository.dart';
import '../datasources/cycle_local_data_source.dart';

class CycleRepositoryImpl implements CycleRepository {
  final CycleLocalDataSource localDataSource;

  const CycleRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, CycleStatus>> getCurrentCycleStatus() async {
    try {
      final window = await localDataSource.getCurrentWindow();
      return Right(CycleStatus(currentWindow: window, isResetDay: false));
    } catch (e) {
      return Left(CycleFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> executeWeeklyWipe() async {
    try {
      await localDataSource.wipeCycleDatabase();
      return const Right(null);
    } catch (e) {
      return Left(CycleFailure(e.toString()));
    }
  }
}
