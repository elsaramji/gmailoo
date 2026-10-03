import 'package:equatable/equatable.dart';

abstract class CategorizationState extends Equatable {
  const CategorizationState();
  @override
  List<Object?> get props => [];
}

class CategorizationInitial extends CategorizationState {}
class CategorizationLoading extends CategorizationState {}
class CategorizationSaved extends CategorizationState {}
class CategorizationError extends CategorizationState {
  final String message;
  const CategorizationError(this.message);
  @override
  List<Object?> get props => [message];
}
