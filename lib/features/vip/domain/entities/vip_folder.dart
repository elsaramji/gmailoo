import 'package:equatable/equatable.dart';
import 'vip_sender.dart';

class VipFolder extends Equatable {
  final String id;
  final String name;
  final VipSender sender;

  const VipFolder({
    required this.id,
    required this.name,
    required this.sender,
  });

  @override
  List<Object?> get props => [id, name, sender];
}
