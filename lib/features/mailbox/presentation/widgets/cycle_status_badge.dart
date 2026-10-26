// lib/features/mailbox/presentation/widgets/cycle_status_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../../../l10n/l10n.dart';

class CycleStatusBadge extends StatelessWidget {
  final VoidCallback? onTap;

  const CycleStatusBadge({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(99.r),
          border: Border.all(color: colors.outline, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 14.r,
              color: colors.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              l10n.cycleStatusBadge(MockCycleFixture.activeDaysRemaining),
              style: textTheme.labelSmall?.copyWith(
                color: colors.onSurfaceMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
