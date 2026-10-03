import '../../domain/entities/vip_sender.dart';

class VipSenderModel extends VipSender {
  const VipSenderModel({
    required super.email,
    required super.displayName,
    super.isMuted,
  });

  factory VipSenderModel.fromJson(Map<String, dynamic> json) {
    return VipSenderModel(
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      isMuted: json['isMuted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'displayName': displayName,
    'isMuted': isMuted,
  };
}
