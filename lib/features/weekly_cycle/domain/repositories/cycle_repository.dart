import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/cycle_status.dart';

abstract class CycleRepository {
  Future<Either<Failure, CycleStatus>> getCurrentCycleStatus();
  Future<Either<Failure, void>> executeWeeklyWipe();
}
