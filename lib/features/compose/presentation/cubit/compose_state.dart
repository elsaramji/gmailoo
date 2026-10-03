import 'package:equatable/equatable.dart';

abstract class ComposeState extends Equatable {
  const ComposeState();
  @override
  List<Object?> get props => [];
}

class ComposeInitial extends ComposeState {}
class ComposeSending extends ComposeState {}
class ComposeSent extends ComposeState {}
class ComposeDraftSaved extends ComposeState {}
class ComposeScheduled extends ComposeState {}
class ComposeError extends ComposeState {
  final String message;
  const ComposeError(this.message);
  @override
  List<Object?> get props => [message];
}
