import 'package:equatable/equatable.dart';
import 'mail_bucket.dart';

class SenderOverride extends Equatable {
  final String senderAddress;
  final MailBucket forcedBucket;

  const SenderOverride({
    required this.senderAddress,
    required this.forcedBucket,
  });

  @override
  List<Object?> get props => [senderAddress, forcedBucket];
}
