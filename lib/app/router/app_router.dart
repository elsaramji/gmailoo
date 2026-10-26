// lib/app/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/compose/presentation/pages/compose_page.dart';
import '../../features/mailbox/presentation/pages/email_detail_page.dart';
import '../../features/mailbox/presentation/pages/mailbox_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/timetables/presentation/pages/timetables_screen.dart';
import '../../features/vip/presentation/pages/vip_folders_page.dart';
import '../../features/weekly_cycle/presentation/pages/zen_day_page.dart';
import 'app_scaffold_with_nav_bar.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteNames.auth,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: RouteNames.zenDay,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ZenDayPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppScaffoldWithNavBar(
        navigationShell: navigationShell,
      ),
      branches: [
        // Tab 0: Inbox
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.inbox,
              builder: (context, state) => const MailboxPage(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => EmailDetailPage(
                    emailId: state.pathParameters['id'] ?? 'msg_001',
                  ),
                ),
                GoRoute(
                  path: 'compose',
                  parentNavigatorKey: _rootNavigatorKey,
                  pageBuilder: (context, state) => const MaterialPage(
                    fullscreenDialog: true,
                    child: ComposePage(),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Tab 1: Timetables
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.timetables,
              builder: (context, state) => const TimetablesScreen(),
            ),
          ],
        ),
        // Tab 2: VIPs
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.vips,
              builder: (context, state) => const VipFoldersPage(),
            ),
          ],
        ),
        // Tab 3: Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouteNames.settings,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
