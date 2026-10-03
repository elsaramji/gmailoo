import 'cycle_database.dart';

abstract class CycleDatabaseFactory {
  Future<CycleDatabase> openCurrentCycle(String cycleId);
  Future<void> deleteCycleFiles();
}
