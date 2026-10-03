import 'package:equatable/equatable.dart';
import 'cycle_window.dart';

class CycleStatus extends Equatable {
  final CycleWindow currentWindow;
  final bool isResetDay;

  const CycleStatus({
    required this.currentWindow,
    required this.isResetDay,
  });

  @override
  List<Object?> get props => [currentWindow, isResetDay];
}
