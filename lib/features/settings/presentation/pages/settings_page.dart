// lib/features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/locale_cubit.dart';
import '../../../../app/theme/theme_cubit.dart';
import '../../../../core/design_system/colors.dart';
import '../../../../core/design_system/dimensions.dart';
import '../../../../core/design_system/typography.dart';
import '../../../../core/mock/mock_fixtures.dart';
import '../../../../l10n/l10n.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _zenNotificationsOnly = true;
  bool _quietHoursEnabled = true;
  bool _useArabicIndicDigits = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final themeMode = context.watch<ThemeCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;
    final isArabic = currentLocale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: GmailooTypography.displayFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ResponsiveBreakpoints.constrainedBody(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connected Account Card
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colors.outline),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: colors.primaryContainer,
                      child: Text(
                        'MB',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Mahmoud Badawy',
                                style: textTheme.titleSmall?.copyWith(
                                  color: colors.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Icon(Icons.check_circle_rounded, size: 14.r, color: colors.success),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'mahmoud@gmail.com',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceSubtle,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: colors.surfaceVariant,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Google Workspace',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.primary,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              _buildSectionHeader(l10n.settingsAppearance),
              SizedBox(height: 8.h),

              // Appearance Card (Theme & Language Switching)
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
                    // Theme Mode Selector
                    Text(
                      l10n.settingsTheme,
                      style: textTheme.titleSmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SegmentedButton<ThemeMode>(
                      segments: [
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text(l10n.settingsThemeLight),
                          icon: const Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text(l10n.settingsThemeDark),
                          icon: const Icon(Icons.dark_mode_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text(l10n.settingsThemeSystem),
                          icon: const Icon(Icons.settings_brightness_outlined),
                        ),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (newSelection) {
                        context.read<ThemeCubit>().updateThemeMode(newSelection.first);
                      },
                      style: ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),
                    const Divider(),
                    SizedBox(height: 14.h),

                    // Language Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.settingsLanguage,
                              style: textTheme.titleSmall?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              isArabic ? l10n.settingsLanguageAr : l10n.settingsLanguageEn,
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceSubtle,
                              ),
                            ),
                          ],
                        ),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'ar',
                              label: Text('العربية'),
                            ),
                            ButtonSegment(
                              value: 'en',
                              label: Text('English'),
                            ),
                          ],
                          selected: {currentLocale.languageCode},
                          onSelectionChanged: (newSelection) {
                            if (newSelection.first == 'ar') {
                              context.read<LocaleCubit>().switchToArabic();
                            } else {
                              context.read<LocaleCubit>().switchToEnglish();
                            }
                          },
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.h),
                    const Divider(),
                    SizedBox(height: 14.h),

                    // Digit Style
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.settingsDigits,
                          style: textTheme.titleSmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ChoiceChip(
                          label: Text(_useArabicIndicDigits
                              ? l10n.settingsDigitsIndic
                              : l10n.settingsDigitsWestern),
                          selected: _useArabicIndicDigits,
                          onSelected: (selected) {
                            setState(() => _useArabicIndicDigits = selected);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              _buildSectionHeader(l10n.settingsNotifications),
              SizedBox(height: 8.h),

              // Notifications Card
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: colors.outline),
                ),
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.settingsNotifications,
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.settingsNotificationsDesc,
                        style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceSubtle),
                      ),
                      value: _zenNotificationsOnly,
                      activeTrackColor: colors.primary,
                      onChanged: (val) => setState(() => _zenNotificationsOnly = val),
                    ),
                    const Divider(),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        l10n.settingsQuietHours,
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: _quietHoursEnabled,
                      activeTrackColor: colors.primary,
                      onChanged: (val) => setState(() => _quietHoursEnabled = val),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              _buildSectionHeader(l10n.settingsStorage),
              SizedBox(height: 8.h),

              // Storage Card
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
                        Text(
                          l10n.settingsCacheSize(MockSettingsFixture.storageCachedSize),
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.inventory_2_outlined, size: 20.r, color: colors.onSurfaceSubtle),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.error,
                        side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
                        minimumSize: Size(double.infinity, 42.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.settingsClearCache)),
                        );
                      },
                      child: Text(l10n.settingsClearCache),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
              // Sign Out Button
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.buckets.unread.container,
                  foregroundColor: colors.buckets.unread.onContainer,
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () {
                  context.go(RouteNames.onboarding);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, size: 18.r),
                    SizedBox(width: 8.w),
                    Text(l10n.settingsSignOut),
                  ],
                ),
              ),

              SizedBox(height: 20.h),
              Center(
                child: Text(
                  '${l10n.settingsVersion} • ${MockSettingsFixture.version}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceSubtle,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      title,
      style: textTheme.titleSmall?.copyWith(
        fontFamily: GmailooTypography.displayFont,
        color: colors.onSurfaceMuted,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
