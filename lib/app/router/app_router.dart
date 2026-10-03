import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/mailbox/presentation/pages/mailbox_page.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.signIn,
  routes: [
    GoRoute(
      path: RouteNames.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: RouteNames.mailbox,
      builder: (context, state) => const MailboxPage(),
    ),
  ],
);
