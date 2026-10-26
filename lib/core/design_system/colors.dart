import 'package:flutter/material.dart';
export '../utils/context_builder.dart';

@immutable
class BucketColor {
  const BucketColor({
    required this.accent,
    required this.container,
    required this.onContainer,
  });

  /// The graphical accent color (leading bar, indicator dot, icon).
  /// NOTE: According to design system rule 4, never use accent as text color.
  final Color accent;

  /// The background fill for chips, pills, and row tint.
  final Color container;

  /// High contrast text and icon color placed on top of [container].
  final Color onContainer;
}

@immutable
class BucketPalette {
  const BucketPalette({
    required this.unread,
    required this.important,
    required this.timetables,
    required this.marketing,
    required this.vip,
  });

  final BucketColor unread;
  final BucketColor important;
  final BucketColor timetables;
  final BucketColor marketing;
  final BucketColor vip;
}

@immutable
class GmailooColors extends ThemeExtension<GmailooColors> {
  const GmailooColors({
    required this.bg,
    required this.surface,
    required this.surfaceVariant,
    required this.outline,
    required this.outlineStrong,
    required this.onSurface,
    required this.onSurfaceMuted,
    required this.onSurfaceSubtle,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.success,
    required this.error,
    required this.onError,
    required this.warning,
    required this.info,
    required this.buckets,
  });

  final Color bg;
  final Color surface;
  final Color surfaceVariant;
  final Color outline;
  final Color outlineStrong;
  final Color onSurface;
  final Color onSurfaceMuted;
  final Color onSurfaceSubtle;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color success;
  final Color error;
  final Color onError;
  final Color warning;
  final Color info;
  final BucketPalette buckets;

  static const light = GmailooColors(
    bg: Color(0xFFF7F7FB),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEEF0F7),
    outline: Color(0xFFD5D9E6),
    outlineStrong: Color(0xFF7C829E),
    onSurface: Color(0xFF14162B),
    onSurfaceMuted: Color(0xFF4A4F6A),
    onSurfaceSubtle: Color(0xFF646A86),
    primary: Color(0xFF4F46E5),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE8E7FD),
    onPrimaryContainer: Color(0xFF2A2486),
    success: Color(0xFF0B7A5C),
    error: Color(0xFFC62828),
    onError: Color(0xFFFFFFFF),
    warning: Color(0xFF9A5B00),
    info: Color(0xFF1F6FD1),
    buckets: BucketPalette(
      unread: BucketColor(
        accent: Color(0xFFE5484D),
        container: Color(0xFFFDECEC),
        onContainer: Color(0xFF8C1D21),
      ),
      important: BucketColor(
        accent: Color(0xFFB86E00),
        container: Color(0xFFFFF3D6),
        onContainer: Color(0xFF6B4300),
      ),
      timetables: BucketColor(
        accent: Color(0xFF2F7DE1),
        container: Color(0xFFE5F0FF),
        onContainer: Color(0xFF0F3D7A),
      ),
      marketing: BucketColor(
        accent: Color(0xFF7C829E),
        container: Color(0xFFEEF0F5),
        onContainer: Color(0xFF4A4F6A),
      ),
      vip: BucketColor(
        accent: Color(0xFFD6409F),
        container: Color(0xFFFDE7F4),
        onContainer: Color(0xFF7A1B55),
      ),
    ),
  );

  static const dark = GmailooColors(
    bg: Color(0xFF0E1020),
    surface: Color(0xFF171A2E),
    surfaceVariant: Color(0xFF20243D),
    outline: Color(0xFF343A5C),
    outlineStrong: Color(0xFF7479A0),
    onSurface: Color(0xFFF1F2FA),
    onSurfaceMuted: Color(0xFFB4B9D6),
    onSurfaceSubtle: Color(0xFF9298BA),
    primary: Color(0xFF9A94FF),
    onPrimary: Color(0xFF14123F),
    primaryContainer: Color(0xFF2D2A6E),
    onPrimaryContainer: Color(0xFFE3E1FF),
    success: Color(0xFF3DD6A8),
    error: Color(0xFFFF8A80),
    onError: Color(0xFF3B0A07),
    warning: Color(0xFFFFB84D),
    info: Color(0xFF7DB2FF),
    buckets: BucketPalette(
      unread: BucketColor(
        accent: Color(0xFFFF6B70),
        container: Color(0xFF3D1A1D),
        onContainer: Color(0xFFFFB9BB),
      ),
      important: BucketColor(
        accent: Color(0xFFFFB84D),
        container: Color(0xFF3A2A0B),
        onContainer: Color(0xFFFFD99A),
      ),
      timetables: BucketColor(
        accent: Color(0xFF5AA0FF),
        container: Color(0xFF14284A),
        onContainer: Color(0xFFB5D4FF),
      ),
      marketing: BucketColor(
        accent: Color(0xFF9298BA),
        container: Color(0xFF1E2136),
        onContainer: Color(0xFFB4B9D6),
      ),
      vip: BucketColor(
        accent: Color(0xFFF06FBF),
        container: Color(0xFF3D1530),
        onContainer: Color(0xFFFFB3E0),
      ),
    ),
  );

  @override
  GmailooColors lerp(ThemeExtension<GmailooColors>? other, double t) {
    if (other is! GmailooColors) return this;
    return t < 0.5 ? this : other;
  }

  @override
  GmailooColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceVariant,
    Color? outline,
    Color? outlineStrong,
    Color? onSurface,
    Color? onSurfaceMuted,
    Color? onSurfaceSubtle,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? success,
    Color? error,
    Color? onError,
    Color? warning,
    Color? info,
    BucketPalette? buckets,
  }) {
    return GmailooColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      outline: outline ?? this.outline,
      outlineStrong: outlineStrong ?? this.outlineStrong,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      onSurfaceSubtle: onSurfaceSubtle ?? this.onSurfaceSubtle,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      success: success ?? this.success,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      buckets: buckets ?? this.buckets,
    );
  }

  /// Maps to Material 3 ColorScheme so stock Flutter widgets adapt seamlessly.
  ColorScheme toColorScheme(Brightness brightness) => ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: primary,
        onSecondary: onPrimary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        outline: outlineStrong,
        outlineVariant: outline,
      );
}
