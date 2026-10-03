import 'dart:ui' show TextDirection;

class TextDirectionHelper {
  static TextDirection directionOf(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final firstRtl = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return firstRtl.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }
}
