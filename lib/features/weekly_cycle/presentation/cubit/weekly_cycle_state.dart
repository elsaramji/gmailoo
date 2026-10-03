import 'package:equatable/equatable.dart';
import '../../domain/entities/cycle_status.dart';

abstract class WeeklyCycleState extends Equatable {
  const WeeklyCycleState();
  @override
  List<Object?> get props => [];
}

class WeeklyCycleInitial extends WeeklyCycleState {}
class WeeklyCycleLoading extends WeeklyCycleState {}
class WeeklyCycleLoaded extends WeeklyCycleState {
  final CycleStatus status;
  const WeeklyCycleLoaded(this.status);
  @override
  List<Object?> get props => [status];
}
class WeeklyCycleWiped extends WeeklyCycleState {}
class WeeklyCycleError extends WeeklyCycleState {
  final String message;
  const WeeklyCycleError(this.message);
  @override
  List<Object?> get props => [message];
}
