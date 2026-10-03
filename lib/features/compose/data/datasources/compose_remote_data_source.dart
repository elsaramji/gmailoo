abstract class ComposeRemoteDataSource {
  Future<void> sendRawEmail({
    required String to,
    String? cc,
    String? bcc,
    required String subject,
    required String body,
  });
}
