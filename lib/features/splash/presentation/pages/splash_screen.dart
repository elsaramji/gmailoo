// lib/features/splash/presentation/pages/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../l10n/l10n.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        context.go(RouteNames.inbox);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      body: ResponsiveBreakpoints.constrainedBody(
        child: Stack(
          children: [
            // Ambient Indigo Glow
            Positioned(
              top: 150.h,
              left: 50.w,
              right: 50.w,
              child: Center(
                child: Container(
                  width: 240.w,
                  height: 240.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.primary.withValues(alpha: 0.08),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),
                    // Squircle Logo Badge
                    Container(
                      width: 88.w,
                      height: 88.w,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: colors.outline, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: colors.onSurface.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.mail_outline_rounded,
                            size: 42.r,
                            color: colors.primary,
                          ),
                          Positioned(
                            top: 22.r,
                            right: 22.r,
                            child: Container(
                              width: 10.r,
                              height: 10.r,
                              decoration: BoxDecoration(
                                color: colors.buckets.unread.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Cairo Wordmark
                    Text(
                      '${l10n.appName} •',
                      style: textTheme.displayLarge?.copyWith(
                        fontFamily: GmailooTypography.displayFont,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.tagline,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 3),
                    // Sync Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99.r),
                      child: SizedBox(
                        width: 160.w,
                        height: 4.h,
                        child: LinearProgressIndicator(
                          backgroundColor: colors.primaryContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      l10n.splashSyncing,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceSubtle,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Security Footnote
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14.r,
                          color: colors.outlineStrong,
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            l10n.splashSecurityFootnote,
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.outlineStrong,
                              fontSize: 10.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
