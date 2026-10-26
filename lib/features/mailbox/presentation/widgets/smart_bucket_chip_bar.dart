// lib/features/mailbox/presentation/widgets/smart_bucket_chip_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../l10n/l10n.dart';
import '../../../categorization/domain/entities/mail_bucket.dart';

class SmartBucketChipBar extends StatelessWidget {
  final MailBucket? selectedBucket;
  final ValueChanged<MailBucket?> onSelected;

  const SmartBucketChipBar({
    super.key,
    required this.selectedBucket,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final chips = [
      _ChipItem(
        bucket: null,
        label: l10n.bucketAll,
        containerColor: colors.primaryContainer,
        textColor: colors.onPrimaryContainer,
        icon: Icons.all_inbox_rounded,
      ),
      _ChipItem(
        bucket: MailBucket.importantUnread,
        label: l10n.bucketImportantUnread,
        containerColor: colors.buckets.unread.container,
        textColor: colors.buckets.unread.onContainer,
        accentDot: colors.buckets.unread.accent,
        icon: Icons.mark_email_unread_rounded,
      ),
      _ChipItem(
        bucket: MailBucket.timetables,
        label: l10n.bucketTimetables,
        containerColor: colors.buckets.timetables.container,
        textColor: colors.buckets.timetables.onContainer,
        icon: Icons.calendar_month_rounded,
      ),
      _ChipItem(
        bucket: MailBucket.other,
        label: l10n.bucketVip,
        containerColor: colors.buckets.vip.container,
        textColor: colors.buckets.vip.onContainer,
        icon: Icons.star_rounded,
      ),
      _ChipItem(
        bucket: MailBucket.marketing,
        label: l10n.bucketMarketing,
        containerColor: colors.buckets.marketing.container,
        textColor: colors.buckets.marketing.onContainer,
        icon: Icons.sell_rounded,
      ),
    ];

    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: chips.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = chips[index];
          final isSelected = selectedBucket == item.bucket;

          return InkWell(
            onTap: () => onSelected(item.bucket),
            borderRadius: BorderRadius.circular(99.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: isSelected ? item.containerColor : colors.surface,
                borderRadius: BorderRadius.circular(99.r),
                border: Border.all(
                  color: isSelected ? colors.primary : colors.outline,
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (item.accentDot != null) ...[
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: item.accentDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                  ] else ...[
                    Icon(
                      item.icon,
                      size: 14.r,
                      color: isSelected ? item.textColor : colors.onSurfaceSubtle,
                    ),
                    SizedBox(width: 6.w),
                  ],
                  Text(
                    item.label,
                    style: textTheme.labelMedium?.copyWith(
                      color: isSelected ? item.textColor : colors.onSurfaceMuted,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChipItem {
  final MailBucket? bucket;
  final String label;
  final Color containerColor;
  final Color textColor;
  final Color? accentDot;
  final IconData icon;

  const _ChipItem({
    required this.bucket,
    required this.label,
    required this.containerColor,
    required this.textColor,
    this.accentDot,
    required this.icon,
  });
}
