// lib/features/onboarding/presentation/pages/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../l10n/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < 2) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(RouteNames.auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final slides = [
      _OnboardingSlideData(
        title: l10n.onboardingTitle1,
        body: l10n.onboardingBody1,
        icon: Icons.auto_delete_outlined,
        accentColor: colors.primary,
        previewBadge: l10n.authTrustPoint3,
      ),
      _OnboardingSlideData(
        title: l10n.onboardingTitle2,
        body: l10n.onboardingBody2,
        icon: Icons.spa_outlined,
        accentColor: colors.buckets.timetables.accent,
        previewBadge: l10n.authTrustPoint1,
      ),
      _OnboardingSlideData(
        title: l10n.onboardingTitle3,
        body: l10n.onboardingBody3,
        icon: Icons.star_border_rounded,
        accentColor: colors.buckets.vip.accent,
        previewBadge: l10n.authTrustPoint4,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.bg,
      body: ResponsiveBreakpoints.constrainedBody(
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.appName} •',
                      style: textTheme.headlineSmall?.copyWith(
                        fontFamily: GmailooTypography.displayFont,
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(RouteNames.inbox),
                      child: Text(
                        l10n.onboardingSkip,
                        style: textTheme.labelLarge?.copyWith(
                          color: colors.onSurfaceSubtle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentIndex = index),
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    final slide = slides[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Tiered Card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(24.r),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: colors.outline),
                              boxShadow: [
                                BoxShadow(
                                  color: colors.onSurface.withValues(alpha: 0.04),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 64.w,
                                  height: 64.w,
                                  decoration: BoxDecoration(
                                    color: slide.accentColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    slide.icon,
                                    size: 32.r,
                                    color: slide.accentColor,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Text(
                                  slide.title,
                                  style: textTheme.headlineSmall?.copyWith(
                                    fontFamily: GmailooTypography.displayFont,
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  slide.body,
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceMuted,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20.h),
                                // Floating Badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(99.r),
                                    border: Border.all(color: colors.outline),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 14.r,
                                        color: colors.success,
                                      ),
                                      SizedBox(width: 6.w),
                                      Flexible(
                                        child: Text(
                                          slide.previewBadge,
                                          style: textTheme.labelSmall?.copyWith(
                                            color: colors.onSurfaceMuted,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (index) {
                  final isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: isActive ? 28.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: isActive ? colors.primary : colors.outline,
                      borderRadius: BorderRadius.circular(99.r),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24.h),
              // Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: _onNext,
                      child: Text(
                        _currentIndex == slides.length - 1
                            ? l10n.onboardingGetStarted
                            : l10n.done,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextButton(
                      onPressed: () => context.go(RouteNames.auth),
                      child: Text(
                        l10n.onboardingSignInPrompt,
                        style: textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideData {
  final String title;
  final String body;
  final IconData icon;
  final Color accentColor;
  final String previewBadge;

  const _OnboardingSlideData({
    required this.title,
    required this.body,
    required this.icon,
    required this.accentColor,
    required this.previewBadge,
  });
}
