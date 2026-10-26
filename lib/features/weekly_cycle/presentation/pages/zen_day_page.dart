// lib/features/weekly_cycle/presentation/pages/zen_day_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/zen_metric_card.dart';

class ZenDayPage extends StatelessWidget {
  const ZenDayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.inbox);
            }
          },
        ),
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Lotus Orb Emblem
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.spa_rounded,
                    size: 36.r,
                    color: colors.primary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Headlines
              Text(
                l10n.zenDayTitle,
                style: textTheme.headlineSmall?.copyWith(
                  fontFamily: GmailooTypography.displayFont,
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                '«${l10n.zenDaySubtitleAr}»',
                style: textTheme.titleMedium?.copyWith(
                  fontFamily: GmailooTypography.displayFont,
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                l10n.zenDayDescription,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceMuted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // 2x2 Serenity Snapshot Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 1.35,
                children: [
                  ZenMetricCard(
                    count: '${MockZenDayFixture.totalEmailsCleared}',
                    label: l10n.zenStatCleared,
                    icon: Icons.auto_delete_outlined,
                    iconColor: colors.primary,
                    containerColor: colors.primaryContainer,
                  ),
                  ZenMetricCard(
                    count: '${MockZenDayFixture.vipEmailsResolved}',
                    label: l10n.zenStatVip,
                    icon: Icons.star_rounded,
                    iconColor: colors.buckets.vip.accent,
                    containerColor: colors.buckets.vip.container,
                  ),
                  ZenMetricCard(
                    count: '${MockZenDayFixture.timetablesSynced}',
                    label: l10n.zenStatTimetables,
                    icon: Icons.event_available_rounded,
                    iconColor: colors.buckets.timetables.accent,
                    containerColor: colors.buckets.timetables.container,
                  ),
                  ZenMetricCard(
                    count: '${MockZenDayFixture.marketingMuted}',
                    label: l10n.zenStatMarketing,
                    icon: Icons.volume_off_rounded,
                    iconColor: colors.buckets.marketing.accent,
                    containerColor: colors.buckets.marketing.container,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Trust Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: colors.outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 16.r, color: colors.success),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        l10n.zenTrustBadge,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceMuted,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              // Cycle reset card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.update_rounded, size: 16.r, color: colors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      l10n.zenNextCycle(MockZenDayFixture.hoursRemainingUntilReset),
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Action Buttons
              FilledButton(
                onPressed: () => context.go(RouteNames.inbox),
                child: Text(l10n.zenEnjoyWeekend),
              ),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.openInGmail)),
                  );
                },
                child: Text(
                  l10n.openInGmail,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
