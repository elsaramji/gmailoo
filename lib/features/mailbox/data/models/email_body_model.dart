import '../../domain/entities/email_body.dart';

class EmailBodyModel extends EmailBody {
  const EmailBodyModel({
    required super.messageId,
    super.textPlain,
    super.textHtml,
  });
}
