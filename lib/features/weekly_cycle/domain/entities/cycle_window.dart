import 'package:equatable/equatable.dart';

class CycleWindow extends Equatable {
  final String cycleId;
  final DateTime startUtc;
  final DateTime endUtc;

  const CycleWindow({
    required this.cycleId,
    required this.startUtc,
    required this.endUtc,
  });

  @override
  List<Object?> get props => [cycleId, startUtc, endUtc];
}
