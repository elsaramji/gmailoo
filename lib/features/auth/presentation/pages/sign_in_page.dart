// lib/features/auth/presentation/pages/sign_in_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/locale_cubit.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/utils/context_builder.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final currentLocale = context.watch<LocaleCubit>().state;
    final isArabic = currentLocale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.onboarding);
            }
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: ActionChip(
              avatar: Icon(Icons.language_rounded, size: 16.r, color: colors.primary),
              label: Text(
                isArabic ? 'English' : 'العربية',
                style: textTheme.labelSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.w600),
              ),
              backgroundColor: colors.primaryContainer,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99.r)),
              onPressed: () => context.read<LocaleCubit>().toggleLocale(),
            ),
          ),
        ],
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 12.h),
                // Monogram Badge
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'G•',
                      style: textTheme.headlineSmall?.copyWith(
                        fontFamily: GmailooTypography.displayFont,
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  l10n.authHeadline,
                  style: textTheme.headlineSmall?.copyWith(
                    fontFamily: GmailooTypography.displayFont,
                    color: colors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.authSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                // Google OAuth Button
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.surface,
                    foregroundColor: colors.onSurface,
                    side: BorderSide(color: colors.outline, width: 1.2),
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  onPressed: () => context.go(RouteNames.inbox),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.g_mobiledata_rounded, size: 28.r, color: Colors.blueAccent),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.authContinueWithGoogle,
                        style: textTheme.labelLarge?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // High-Trust Privacy Container
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: colors.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verified badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user_rounded, size: 14.r, color: colors.onPrimaryContainer),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Text(
                                l10n.authOfficialScopeBadge,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildTrustPoint(context, l10n.authTrustPoint1),
                      SizedBox(height: 10.h),
                      _buildTrustPoint(context, l10n.authTrustPoint2),
                      SizedBox(height: 10.h),
                      _buildTrustPoint(context, l10n.authTrustPoint3),
                      SizedBox(height: 10.h),
                      _buildTrustPoint(context, l10n.authTrustPoint4),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Legal Footer
                Text(
                  l10n.authLegalFooter,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceSubtle,
                    fontSize: 11.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrustPoint(BuildContext context, String text) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_rounded, size: 16.r, color: colors.success),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceMuted,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
