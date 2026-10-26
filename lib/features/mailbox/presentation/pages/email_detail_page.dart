// lib/features/mailbox/presentation/pages/email_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../../../core/utils/bidi_detector.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/bucket_badge.dart';

class EmailDetailPage extends StatefulWidget {
  final String emailId;

  const EmailDetailPage({super.key, required this.emailId});

  @override
  State<EmailDetailPage> createState() => _EmailDetailPageState();
}

class _EmailDetailPageState extends State<EmailDetailPage> {
  late MockEmailDetail _detail;
  late bool _isVip;

  @override
  void initState() {
    super.initState();
    _detail = MockEmailFixtures.findById(widget.emailId);
    _isVip = _detail.isVip;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final email = _detail.email;

    final senderName = email.from.split('<').first.trim();
    final senderEmail = email.from.contains('<')
        ? email.from.split('<').last.replaceAll('>', '').trim()
        : email.from;
    final initials = senderName.isNotEmpty
        ? (senderName
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join())
        : 'M';

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          // VIP Star Toggle
          IconButton(
            icon: Icon(
              _isVip ? Icons.star_rounded : Icons.star_border_rounded,
              color: _isVip
                  ? colors.buckets.vip.accent
                  : colors.onSurfaceSubtle,
              size: 26.r,
            ),
            onPressed: () {
              setState(() => _isVip = !_isVip);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isVip ? l10n.bucketVip : l10n.bucketAll),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          // Synced Pill
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: BorderRadius.circular(99.r),
                border: Border.all(color: colors.outline),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_done_rounded,
                    size: 14.r,
                    color: colors.success,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    l10n.syncedWithGmail,
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceMuted,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 100.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colors.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BucketBadge(
                          bucket: email.bucket,
                          isUnread: email.isUnread,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            l10n.daysRemaining(
                              MockCycleFixture.activeDaysRemaining,
                            ),
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceSubtle,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Subject
                    Text(
                      email.subject,
                      textDirection: directionOf(email.subject),
                      style: textTheme.titleMedium?.copyWith(
                        fontFamily: GmailooTypography.displayFont,
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 14.h),
                    const Divider(),
                    SizedBox(height: 12.h),
                    // Sender info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: colors.surfaceVariant,
                          child: Text(
                            initials.toUpperCase(),
                            style: textTheme.labelMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      senderName,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colors.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (_detail.vipRole != null) ...[
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.buckets.vip.container,
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        _detail.vipRole!,
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colors.buckets.vip.onContainer,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                senderEmail,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceSubtle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Extracted Event Component (if present)
              if (_detail.event != null) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: colors.buckets.timetables.container,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: colors.buckets.timetables.accent.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.event_available_rounded,
                                size: 18.r,
                                color: colors.buckets.timetables.onContainer,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                _detail.event!.title,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleSmall?.copyWith(
                                  color: colors.buckets.timetables.onContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          if (_detail.event!.isSynced)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                l10n.eventSynced,
                                style: textTheme.labelSmall?.copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  color: colors.success,
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '${_detail.event!.startTime} - ${_detail.event!.endTime}',

                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.buckets.timetables.onContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _detail.event!.location,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.buckets.timetables.onContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.surface,
                          foregroundColor:
                              colors.buckets.timetables.onContainer,
                          minimumSize: Size(double.infinity, 38.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.eventSynced)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 16),
                            SizedBox(width: 6.w),
                            Text(l10n.addToCalendar),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Attachments (if present)
              if (email.attachments.isNotEmpty) ...[
                SizedBox(height: 12.h),
                ...email.attachments.map((att) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: colors.outline),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: colors.surfaceVariant,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.picture_as_pdf_rounded,
                            color: colors.error,
                            size: 24.r,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                att.filename,
                                style: textTheme.titleSmall?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${(att.sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.onSurfaceSubtle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.download_rounded,
                            color: colors.primary,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${l10n.downloadAttachment}: ${att.filename}',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],

              // Body Card
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.r),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colors.outline),
                ),
                child: Text(
                  _detail.body.textPlain ?? '',
                  textDirection: directionOf(_detail.body.textPlain ?? ''),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurface,
                    height: 1.6,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.outline)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                icon: const Icon(Icons.reply_rounded, size: 18),
                label: Text(l10n.reply),
                onPressed: () => context.push(RouteNames.compose),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.forward_rounded, size: 18),
                label: Text(l10n.forward),
                onPressed: () => context.push(RouteNames.compose),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              tooltip: l10n.openInGmail,
              icon: Icon(Icons.open_in_new_rounded, color: colors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.openInGmail)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
