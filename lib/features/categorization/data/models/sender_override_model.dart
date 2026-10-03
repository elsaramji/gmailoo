import '../../domain/entities/mail_bucket.dart';
import '../../domain/entities/sender_override.dart';

class SenderOverrideModel extends SenderOverride {
  const SenderOverrideModel({
    required super.senderAddress,
    required super.forcedBucket,
  });

  factory SenderOverrideModel.fromJson(Map<String, dynamic> json) {
    return SenderOverrideModel(
      senderAddress: json['senderAddress'] as String,
      forcedBucket: MailBucket.values.firstWhere((e) => e.name == json['forcedBucket']),
    );
  }

  Map<String, dynamic> toJson() => {
    'senderAddress': senderAddress,
    'forcedBucket': forcedBucket.name,
  };
}
