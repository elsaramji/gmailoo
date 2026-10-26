// lib/features/mailbox/presentation/widgets/email_feed_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/utils/bidi_detector.dart';
import '../../domain/entities/email.dart';
import 'bucket_badge.dart';

class EmailFeedCard extends StatelessWidget {
  final Email email;
  final VoidCallback onTap;

  const EmailFeedCard({
    super.key,
    required this.email,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final isUnread = email.isUnread;

    // Extract sender name from 'Name <email@domain>'
    final senderName = email.from.split('<').first.trim();
    final initials = senderName.isNotEmpty
        ? (senderName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join())
        : 'M';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isUnread ? colors.primary.withValues(alpha: 0.3) : colors.outline,
            width: isUnread ? 1.2 : 1.0,
          ),
          boxShadow: [
            if (isUnread)
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Avatar, Sender, Unread Dot, Time
            Row(
              children: [
                CircleAvatar(
                  radius: 16.r,
                  backgroundColor: colors.surfaceVariant,
                  child: Text(
                    initials.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Row(
                    children: [
                      if (isUnread) ...[
                        Container(
                          width: 8.r,
                          height: 8.r,
                          margin: EdgeInsets.only(right: 6.w),
                          decoration: BoxDecoration(
                            color: colors.buckets.unread.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          senderName,
                          textDirection: directionOf(senderName),
                          style: textTheme.titleSmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Received time
                Text(
                  _formatTime(email.receivedAt, context),
                  style: textTheme.labelSmall?.copyWith(
                    color: isUnread ? colors.primary : colors.onSurfaceSubtle,
                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Row 2: Subject
            Text(
              email.subject,
              textDirection: directionOf(email.subject),
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 4.h),
            // Row 3: Snippet
            Text(
              email.snippet,
              textDirection: directionOf(email.snippet),
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceMuted,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10.h),
            // Row 4: Bucket Badge and Attachment indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BucketBadge(bucket: email.bucket, isUnread: isUnread),
                if (email.attachments.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        size: 14.r,
                        color: colors.onSurfaceSubtle,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${email.attachments.length}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceSubtle,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime, BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inHours < 24 && now.day == dateTime.day) {
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } else if (diff.inDays <= 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}
