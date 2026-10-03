class SafeLogger {
  static void log(String message) {
    // Redact emails / PII
    final sanitized = message.replaceAll(RegExp(r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+'), '[REDACTED_EMAIL]');
    // ignore: avoid_print
    print(sanitized);
  }
}
