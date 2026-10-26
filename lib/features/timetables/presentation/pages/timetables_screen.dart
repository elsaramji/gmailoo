// lib/features/timetables/presentation/pages/timetables_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../l10n/l10n.dart';
import '../widgets/timetable_event_card.dart';

class TimetablesScreen extends StatefulWidget {
  const TimetablesScreen({super.key});

  @override
  State<TimetablesScreen> createState() => _TimetablesScreenState();
}

class _TimetablesScreenState extends State<TimetablesScreen> {
  TimetableType? _selectedCategory;

  final List<TimetableItem> _allEvents = const [
    TimetableItem(
      id: 'tt_1',
      title: 'CS402 Distributed Systems Midterm',
      date: 'Sunday, Oct 5',
      time: '10:00 AM – 12:00 PM',
      location: 'Hall 3B • Engineering Campus',
      type: TimetableType.exam,
      isSynced: true,
      attachmentName: 'CS402_Midterm_Seat_Distribution.pdf',
    ),
    TimetableItem(
      id: 'tt_2',
      title: 'جدول المحاضرات والسكاشن المعدل للأسبوع',
      date: 'Monday, Oct 6',
      time: '09:00 AM – 11:00 AM',
      location: 'مدرج 4 - المبنى الرئيسي',
      type: TimetableType.lecture,
      isSynced: false,
      attachmentName: 'CS_Cohort_Schedule.pdf',
    ),
    TimetableItem(
      id: 'tt_3',
      title: 'Sprint 4 Deliverables & Staging Deadline',
      date: 'Wednesday, Oct 8',
      time: '05:00 PM',
      location: 'Remote / GitHub Repo PRs',
      type: TimetableType.deadline,
      isSynced: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final events = _selectedCategory == null
        ? _allEvents
        : _allEvents.where((e) => e.type == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          l10n.timetablesTitle,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: GmailooTypography.displayFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: Column(
          children: [
            // Cycle Summary Banner
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: colors.buckets.timetables.container,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.buckets.timetables.accent.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18.r,
                      color: colors.buckets.timetables.onContainer,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        l10n.timetablesBanner,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.buckets.timetables.onContainer,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Category Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Row(
                children: [
                  _buildFilterChip(null, l10n.filterAll),
                  SizedBox(width: 8.w),
                  _buildFilterChip(TimetableType.exam, l10n.filterExams),
                  SizedBox(width: 8.w),
                  _buildFilterChip(TimetableType.lecture, l10n.filterLectures),
                  SizedBox(width: 8.w),
                  _buildFilterChip(TimetableType.deadline, l10n.filterDeadlines),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            // Events list
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: events.length,
                separatorBuilder: (context, index) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  return TimetableEventCard(item: events[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(TimetableType? type, String label) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final isSelected = _selectedCategory == type;

    return InkWell(
      onTap: () => setState(() => _selectedCategory = type),
      borderRadius: BorderRadius.circular(99.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryContainer : colors.surface,
          borderRadius: BorderRadius.circular(99.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: isSelected ? colors.onPrimaryContainer : colors.onSurfaceMuted,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
