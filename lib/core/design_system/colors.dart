import 'package:flutter/material.dart';

@immutable
class GmailooColors extends ThemeExtension<GmailooColors> {
  final Color brandPrimary;
  final Color bgCanvas;
  final Color bucketUnread;
  final Color bucketImportant;
  final Color bucketTimetables;
  final Color bucketMarketing;
  final Color bucketVip;

  const GmailooColors({
    required this.brandPrimary,
    required this.bgCanvas,
    required this.bucketUnread,
    required this.bucketImportant,
    required this.bucketTimetables,
    required this.bucketMarketing,
    required this.bucketVip,
  });

  static const light = GmailooColors(
    brandPrimary: Color(0xFF4F46E5),
    bgCanvas: Color(0xFFF7F7FB),
    bucketUnread: Color(0xFFE5484D),
    bucketImportant: Color(0xFFB86E00),
    bucketTimetables: Color(0xFF2F7DE1),
    bucketMarketing: Color(0xFF7C829E),
    bucketVip: Color(0xFFD6409F),
  );

  static const dark = GmailooColors(
    brandPrimary: Color(0xFF9A94FF),
    bgCanvas: Color(0xFF13141C),
    bucketUnread: Color(0xFFFF6369),
    bucketImportant: Color(0xFFF5A623),
    bucketTimetables: Color(0xFF5B9DFF),
    bucketMarketing: Color(0xFF9CA3AF),
    bucketVip: Color(0xFFF472B6),
  );

  @override
  GmailooColors copyWith({
    Color? brandPrimary,
    Color? bgCanvas,
    Color? bucketUnread,
    Color? bucketImportant,
    Color? bucketTimetables,
    Color? bucketMarketing,
    Color? bucketVip,
  }) {
    return GmailooColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      bgCanvas: bgCanvas ?? this.bgCanvas,
      bucketUnread: bucketUnread ?? this.bucketUnread,
      bucketImportant: bucketImportant ?? this.bucketImportant,
      bucketTimetables: bucketTimetables ?? this.bucketTimetables,
      bucketMarketing: bucketMarketing ?? this.bucketMarketing,
      bucketVip: bucketVip ?? this.bucketVip,
    );
  }

  @override
  ThemeExtension<GmailooColors> lerp(ThemeExtension<GmailooColors>? other, double t) {
    if (other is! GmailooColors) return this;
    return GmailooColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      bgCanvas: Color.lerp(bgCanvas, other.bgCanvas, t)!,
      bucketUnread: Color.lerp(bucketUnread, other.bucketUnread, t)!,
      bucketImportant: Color.lerp(bucketImportant, other.bucketImportant, t)!,
      bucketTimetables: Color.lerp(bucketTimetables, other.bucketTimetables, t)!,
      bucketMarketing: Color.lerp(bucketMarketing, other.bucketMarketing, t)!,
      bucketVip: Color.lerp(bucketVip, other.bucketVip, t)!,
    );
  }
}
