// lib/features/weekly_cycle/presentation/widgets/zen_metric_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/typography.dart';

class ZenMetricCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color containerColor;

  const ZenMetricCard({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.containerColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.outline),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.r, color: iconColor),
          ),
          SizedBox(height: 10.h),
          Text(
            count,
            style: textTheme.headlineSmall?.copyWith(
              fontFamily: GmailooTypography.displayFont,
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceMuted,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
