// lib/app/router/app_scaffold_with_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design_system/colors.dart';
import '../../l10n/l10n.dart';

class AppScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.bg,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.all_inbox_outlined),
            selectedIcon: const Icon(Icons.all_inbox_rounded),
            label: l10n.tabInbox,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_month_outlined),
            selectedIcon: const Icon(Icons.calendar_month_rounded),
            label: l10n.tabTimetables,
          ),
          NavigationDestination(
            icon: const Icon(Icons.star_outline_rounded),
            selectedIcon: const Icon(Icons.star_rounded),
            label: l10n.tabVips,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: l10n.tabSettings,
          ),
        ],
      ),
    );
  }
}
