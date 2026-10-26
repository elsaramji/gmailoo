// lib/features/timetables/presentation/widgets/timetable_event_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../core/design_system/colors.dart';
import '../../../../core/utils/bidi_detector.dart';
import '../../../../l10n/l10n.dart';

enum TimetableType { exam, lecture, deadline }

class TimetableItem {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final TimetableType type;
  final bool isSynced;
  final String? attachmentName;

  const TimetableItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.type,
    this.isSynced = false,
    this.attachmentName,
  });
}

class TimetableEventCard extends StatelessWidget {
  final TimetableItem item;

  const TimetableEventCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    Color badgeBg;
    Color badgeTextColor;
    String badgeLabel;
    IconData badgeIcon;

    switch (item.type) {
      case TimetableType.exam:
        badgeBg = colors.buckets.unread.container;
        badgeTextColor = colors.buckets.unread.onContainer;
        badgeLabel = l10n.filterExams.toUpperCase();
        badgeIcon = Icons.quiz_outlined;
        break;
      case TimetableType.lecture:
        badgeBg = colors.buckets.timetables.container;
        badgeTextColor = colors.buckets.timetables.onContainer;
        badgeLabel = l10n.filterLectures.toUpperCase();
        badgeIcon = Icons.school_outlined;
        break;
      case TimetableType.deadline:
        badgeBg = colors.buckets.important.container;
        badgeTextColor = colors.buckets.important.onContainer;
        badgeLabel = l10n.filterDeadlines.toUpperCase();
        badgeIcon = Icons.timer_outlined;
        break;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Type Badge & Synced Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 12.r, color: badgeTextColor),
                    SizedBox(width: 4.w),
                    Text(
                      badgeLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: badgeTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isSynced)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 12.r,
                        color: colors.success,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        l10n.eventSynced,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),
          // Row 2: Title
          Text(
            item.title,
            textDirection: directionOf(item.title),
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          // Row 3: Date & Time
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14.r,
                color: colors.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                '${item.date} • ${item.time}',
                overflow: TextOverflow.ellipsis,

                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Row 4: Location
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14.r,
                color: colors.onSurfaceSubtle,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  item.location,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceSubtle,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (item.attachmentName != null) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.picture_as_pdf_rounded,
                    size: 16.r,
                    color: colors.error,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    item.attachmentName!,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
