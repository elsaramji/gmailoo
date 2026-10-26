// lib/core/utils/bidi_detector.dart
import 'package:flutter/material.dart';

/// Detects the reading direction of text based on its first strong character.
/// Used for subjects, snippets, and email body paragraphs so Arabic and English
/// runs are not misaligned or reversed.
TextDirection directionOf(String text) {
  for (final r in text.runes) {
    // Arabic, Hebrew, and other RTL unicode blocks
    if ((r >= 0x0590 && r <= 0x08FF) || (r >= 0xFB1D && r <= 0xFEFC)) {
      return TextDirection.rtl;
    }
    // Latin A-Z, a-z
    if ((r >= 0x41 && r <= 0x5A) || (r >= 0x61 && r <= 0x7A)) {
      return TextDirection.ltr;
    }
  }
  return TextDirection.ltr;
}
