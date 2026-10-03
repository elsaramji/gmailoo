import 'package:equatable/equatable.dart';

class VipSender extends Equatable {
  final String email;
  final String displayName;
  final bool isMuted;

  const VipSender({
    required this.email,
    required this.displayName,
    this.isMuted = false,
  });

  @override
  List<Object?> get props => [email, displayName, isMuted];
}
