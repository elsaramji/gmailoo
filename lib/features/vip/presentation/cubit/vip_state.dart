import 'package:equatable/equatable.dart';
import '../../domain/entities/vip_sender.dart';

abstract class VipState extends Equatable {
  const VipState();
  @override
  List<Object?> get props => [];
}

class VipInitial extends VipState {}
class VipLoading extends VipState {}
class VipLoaded extends VipState {
  final List<VipSender> senders;
  const VipLoaded(this.senders);
  @override
  List<Object?> get props => [senders];
}
class VipError extends VipState {
  final String message;
  const VipError(this.message);
  @override
  List<Object?> get props => [message];
}
