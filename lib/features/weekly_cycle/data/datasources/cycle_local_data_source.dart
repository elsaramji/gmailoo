import '../models/cycle_window_model.dart';

abstract class CycleLocalDataSource {
  Future<CycleWindowModel> getCurrentWindow();
  Future<void> wipeCycleDatabase();
}
