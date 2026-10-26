// lib/features/mailbox/presentation/widgets/bucket_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../categorization/domain/entities/mail_bucket.dart';

class BucketBadge extends StatelessWidget {
  final MailBucket bucket;
  final bool isUnread;

  const BucketBadge({
    super.key,
    required this.bucket,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    BucketColor bucketColor;
    String label;
    IconData icon;

    switch (bucket) {
      case MailBucket.importantUnread:
        bucketColor = colors.buckets.unread;
        label = l10n.bucketImportantUnread;
        icon = Icons.mark_email_unread_rounded;
        break;
      case MailBucket.important:
        bucketColor = colors.buckets.important;
        label = l10n.bucketImportant;
        icon = Icons.priority_high_rounded;
        break;
      case MailBucket.timetables:
        bucketColor = colors.buckets.timetables;
        label = l10n.bucketTimetables;
        icon = Icons.calendar_month_rounded;
        break;
      case MailBucket.marketing:
        bucketColor = colors.buckets.marketing;
        label = l10n.bucketMarketing;
        icon = Icons.sell_rounded;
        break;
      case MailBucket.other:
        bucketColor = colors.buckets.vip;
        label = l10n.bucketVip;
        icon = Icons.star_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bucketColor.container,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12.r,
            color: bucketColor.onContainer,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: bucketColor.onContainer,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
