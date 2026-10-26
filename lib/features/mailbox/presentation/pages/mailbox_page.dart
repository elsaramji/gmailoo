// lib/features/mailbox/presentation/pages/mailbox_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../../../l10n/l10n.dart';
import '../../../categorization/domain/entities/mail_bucket.dart';
import '../../domain/entities/email.dart';
import '../widgets/cycle_status_badge.dart';
import '../widgets/email_feed_card.dart';
import '../widgets/smart_bucket_chip_bar.dart';

class MailboxPage extends StatefulWidget {
  const MailboxPage({super.key});

  @override
  State<MailboxPage> createState() => _MailboxPageState();
}

class _MailboxPageState extends State<MailboxPage> {
  MailBucket? _selectedBucket;
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Email> get _filteredEmails {
    return MockEmailFixtures.emails.where((email) {
      if (_selectedBucket != null) {
        if (_selectedBucket == MailBucket.importantUnread) {
          if (!email.isUnread) return false;
        } else if (_selectedBucket == MailBucket.other) {
          final detail = MockEmailFixtures.findById(email.id);
          if (!detail.isVip) return false;
        } else if (email.bucket != _selectedBucket) {
          return false;
        }
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchSubject = email.subject.toLowerCase().contains(query);
        final matchSnippet = email.snippet.toLowerCase().contains(query);
        final matchFrom = email.from.toLowerCase().contains(query);
        if (!matchSubject && !matchSnippet && !matchFrom) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final emails = _filteredEmails;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        titleSpacing: 16.w,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : Row(
                children: [
                  Text(
                    '${l10n.appName} •',
                    style: textTheme.titleLarge?.copyWith(
                      fontFamily: GmailooTypography.displayFont,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CycleStatusBadge(
                    onTap: () => context.push(RouteNames.zenDay),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              color: colors.onSurface,
            ),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: InkWell(
              onTap: () => context.go(RouteNames.settings),
              borderRadius: BorderRadius.circular(99.r),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: colors.primaryContainer,
                child: Text(
                  'MB',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            // Smart Filter Chips
            SmartBucketChipBar(
              selectedBucket: _selectedBucket,
              onSelected: (bucket) => setState(() => _selectedBucket = bucket),
            ),
            SizedBox(height: 12.h),
            // Email Feed
            Expanded(
              child: emails.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.all_inbox_outlined,
                            size: 48.r,
                            color: colors.outlineStrong,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            _selectedBucket == null ? l10n.emptyInbox : l10n.emptyFilter,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceSubtle,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 80.h),
                      itemCount: emails.length,
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final email = emails[index];
                        return EmailFeedCard(
                          email: email,
                          onTap: () => context.push('/inbox/detail/${email.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        icon: const Icon(Icons.edit_outlined),
        label: Text(
          l10n.compose,
          style: textTheme.labelLarge?.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => context.push(RouteNames.compose),
      ),
    );
  }
}
