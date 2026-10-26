// lib/features/vip/presentation/pages/vip_folders_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../l10n/l10n.dart';

class VipSenderItem {
  final String name;
  final String email;
  final String role;
  final String initials;
  bool isVip;

  VipSenderItem({
    required this.name,
    required this.email,
    required this.role,
    required this.initials,
    this.isVip = true,
  });
}

class VipFoldersPage extends StatefulWidget {
  const VipFoldersPage({super.key});

  @override
  State<VipFoldersPage> createState() => _VipFoldersPageState();
}

class _VipFoldersPageState extends State<VipFoldersPage> {
  final List<VipSenderItem> _vips = [
    VipSenderItem(
      name: 'Dr. Tarek Hegazy',
      email: 'tarek.hegazy@eng.asu.edu.eg',
      role: 'VIP Professor',
      initials: 'TH',
    ),
    VipSenderItem(
      name: 'Omar Khaled',
      email: 'omar.k@gmailoo.co',
      role: 'Co-Founder',
      initials: 'OK',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          l10n.vipsTitle,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: GmailooTypography.displayFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: colors.buckets.vip.container,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.buckets.vip.accent.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 20.r,
                      color: colors.buckets.vip.onContainer,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        l10n.vipsSubtitle,
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.buckets.vip.onContainer,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              // Add VIP button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.outlineStrong),
                  minimumSize: Size(double.infinity, 44.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: Text(l10n.addVip),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.addVip)),
                  );
                },
              ),
              SizedBox(height: 16.h),
              // VIPs List
              Expanded(
                child: ListView.separated(
                  itemCount: _vips.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final vip = _vips[index];
                    return Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.outline),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: colors.buckets.vip.container,
                            child: Text(
                              vip.initials,
                              style: textTheme.titleSmall?.copyWith(
                                color: colors.buckets.vip.onContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      vip.name,
                                      style: textTheme.titleSmall?.copyWith(
                                        color: colors.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: colors.buckets.vip.container,
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: Text(
                                        vip.role,
                                        style: textTheme.labelSmall?.copyWith(
                                          color: colors.buckets.vip.onContainer,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  vip.email,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceSubtle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              vip.isVip ? Icons.star_rounded : Icons.star_border_rounded,
                              color: vip.isVip ? colors.buckets.vip.accent : colors.onSurfaceSubtle,
                            ),
                            onPressed: () {
                              setState(() => vip.isVip = !vip.isVip);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
