import 'package:equatable/equatable.dart';

class EmailBody extends Equatable {
  final String messageId;
  final String? textPlain;
  final String? textHtml;

  const EmailBody({
    required this.messageId,
    this.textPlain,
    this.textHtml,
  });

  @override
  List<Object?> get props => [messageId, textPlain, textHtml];
}
