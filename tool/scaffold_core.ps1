# scaffold_files.ps1
# Generates all placeholder files for Gmailoo Clean Architecture

function Write-DartFile($path, $content) {
  $dir = Split-Path $path -Parent
  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
  }
  Set-Content -Path $path -Value $content.Trim() -Encoding UTF8
}

Write-Output "Generating Core & App files..."

# Bootstrap & App
Write-DartFile "lib/bootstrap.dart" @"
import 'dart:async';
import 'package:flutter/widgets.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(await builder());
}
"@

Write-DartFile "lib/app/app.dart" @"
import 'package:flutter/material.dart';

class GmailooApp extends StatelessWidget {
  const GmailooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gmailoo',
      home: Scaffold(
        body: Center(
          child: Text('Gmailoo Initialized'),
        ),
      ),
    );
  }
}
"@

Write-DartFile "lib/app/router/route_names.dart" @"
class RouteNames {
  static const String root = '/';
  static const String signIn = '/sign-in';
  static const String mailbox = '/mailbox';
  static const String emailDetail = '/email-detail';
  static const String compose = '/compose';
  static const String vipFolders = '/vip-folders';
  static const String zenDay = '/zen-day';
  static const String settings = '/settings';
}
"@

Write-DartFile "lib/app/router/app_router.dart" @"
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
"@

Write-DartFile "lib/app/theme/app_theme.dart" @"
import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        extensions: const [GmailooColors.light],
      );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        extensions: const [GmailooColors.dark],
      );
}
"@

Write-DartFile "lib/app/theme/theme_cubit.dart" @"
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void updateThemeMode(ThemeMode mode) => emit(mode);
}
"@

Write-DartFile "lib/app/di/injection.dart" @"
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Dependencies registration will be handled by injectable or manual wiring
}
"@

# Core error, usecase, time, network, utils
Write-DartFile "lib/core/error/failures.dart" @"
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Local storage error occurred']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);
}

class CycleFailure extends Failure {
  const CycleFailure([super.message = 'Cycle boundary or wipe failure']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server response error']);
}
"@

Write-DartFile "lib/core/error/exceptions.dart" @"
class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'Server Exception']);
}

class CacheException implements Exception {
  final String message;
  const CacheException([this.message = 'Cache Exception']);
}

class AuthException implements Exception {
  final String message;
  const AuthException([this.message = 'Auth Exception']);
}

class CycleException implements Exception {
  final String message;
  const CycleException([this.message = 'Cycle Exception']);
}
"@

Write-DartFile "lib/core/usecase/usecase.dart" @"
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
"@

Write-DartFile "lib/core/time/clock.dart" @"
abstract class Clock {
  DateTime now();
}
"@

Write-DartFile "lib/core/time/system_clock.dart" @"
import 'clock.dart';

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}
"@

Write-DartFile "lib/core/time/cycle_clock.dart" @"
import 'clock.dart';

abstract class CycleClock {
  String cycleIdFor(DateTime dateTime, String timezone);
  bool isResetDay(DateTime dateTime, String timezone);
  (DateTime startUtc, DateTime endUtc) windowFor(String cycleId, String timezone);
  bool isWithinWindow((DateTime startUtc, DateTime endUtc) window, DateTime instant);
}
"@

Write-DartFile "lib/core/network/authenticated_http_client.dart" @"
import 'package:http/http.dart' as http;

abstract class AuthenticatedHttpClient {
  Future<http.Client> getClient();
}
"@

# Core Database (Drift + SQLCipher placeholders)
Write-DartFile "lib/core/database/core/core_database.dart" @"
// Core persistent database representation (gmailoo_core.sqlite)
class CoreDatabase {
  const CoreDatabase();
}
"@

Write-DartFile "lib/core/database/core/tables/session_table.dart" @"
class SessionTable {}
"@

Write-DartFile "lib/core/database/core/tables/app_settings_table.dart" @"
class AppSettingsTable {}
"@

Write-DartFile "lib/core/database/core/tables/vip_senders_table.dart" @"
class VipSendersTable {}
"@

Write-DartFile "lib/core/database/core/tables/sender_overrides_table.dart" @"
class SenderOverridesTable {}
"@

Write-DartFile "lib/core/database/core/tables/outbox_messages_table.dart" @"
class OutboxMessagesTable {}
"@

Write-DartFile "lib/core/database/core/tables/cycle_log_table.dart" @"
class CycleLogTable {}
"@

Write-DartFile "lib/core/database/cycle/cycle_database.dart" @"
// Ephemeral cycle database representation (gmailoo_cycle.sqlite)
class CycleDatabase {
  const CycleDatabase();
}
"@

Write-DartFile "lib/core/database/cycle/cycle_database_factory.dart" @"
import 'cycle_database.dart';

abstract class CycleDatabaseFactory {
  Future<CycleDatabase> openCurrentCycle(String cycleId);
  Future<void> deleteCycleFiles();
}
"@

Write-DartFile "lib/core/database/cycle/tables/cycle_meta_table.dart" @"
class CycleMetaTable {}
"@

Write-DartFile "lib/core/database/cycle/tables/messages_table.dart" @"
class MessagesTable {}
"@

Write-DartFile "lib/core/database/cycle/tables/message_bodies_table.dart" @"
class MessageBodiesTable {}
"@

Write-DartFile "lib/core/database/cycle/tables/attachments_table.dart" @"
class AttachmentsTable {}
"@

Write-DartFile "lib/core/database/cycle/tables/notification_log_table.dart" @"
class NotificationLogTable {}
"@

# Core Design System
Write-DartFile "lib/core/design_system/colors.dart" @"
import 'package:flutter/material.dart';

@immutable
class GmailooColors extends ThemeExtension<GmailooColors> {
  final Color brandPrimary;
  final Color bgCanvas;
  final Color bucketUnread;
  final Color bucketImportant;
  final Color bucketTimetables;
  final Color bucketMarketing;
  final Color bucketVip;

  const GmailooColors({
    required this.brandPrimary,
    required this.bgCanvas,
    required this.bucketUnread,
    required this.bucketImportant,
    required this.bucketTimetables,
    required this.bucketMarketing,
    required this.bucketVip,
  });

  static const light = GmailooColors(
    brandPrimary: Color(0xFF4F46E5),
    bgCanvas: Color(0xFFF7F7FB),
    bucketUnread: Color(0xFFE5484D),
    bucketImportant: Color(0xFFB86E00),
    bucketTimetables: Color(0xFF2F7DE1),
    bucketMarketing: Color(0xFF7C829E),
    bucketVip: Color(0xFFD6409F),
  );

  static const dark = GmailooColors(
    brandPrimary: Color(0xFF9A94FF),
    bgCanvas: Color(0xFF13141C),
    bucketUnread: Color(0xFFFF6369),
    bucketImportant: Color(0xFFF5A623),
    bucketTimetables: Color(0xFF5B9DFF),
    bucketMarketing: Color(0xFF9CA3AF),
    bucketVip: Color(0xFFF472B6),
  );

  @override
  GmailooColors copyWith({
    Color? brandPrimary,
    Color? bgCanvas,
    Color? bucketUnread,
    Color? bucketImportant,
    Color? bucketTimetables,
    Color? bucketMarketing,
    Color? bucketVip,
  }) {
    return GmailooColors(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      bgCanvas: bgCanvas ?? this.bgCanvas,
      bucketUnread: bucketUnread ?? this.bucketUnread,
      bucketImportant: bucketImportant ?? this.bucketImportant,
      bucketTimetables: bucketTimetables ?? this.bucketTimetables,
      bucketMarketing: bucketMarketing ?? this.bucketMarketing,
      bucketVip: bucketVip ?? this.bucketVip,
    );
  }

  @override
  ThemeExtension<GmailooColors> lerp(ThemeExtension<GmailooColors>? other, double t) {
    if (other is! GmailooColors) return this;
    return GmailooColors(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      bgCanvas: Color.lerp(bgCanvas, other.bgCanvas, t)!,
      bucketUnread: Color.lerp(bucketUnread, other.bucketUnread, t)!,
      bucketImportant: Color.lerp(bucketImportant, other.bucketImportant, t)!,
      bucketTimetables: Color.lerp(bucketTimetables, other.bucketTimetables, t)!,
      bucketMarketing: Color.lerp(bucketMarketing, other.bucketMarketing, t)!,
      bucketVip: Color.lerp(bucketVip, other.bucketVip, t)!,
    );
  }
}
"@

Write-DartFile "lib/core/design_system/typography.dart" @"
class GmailooTypography {
  static const String displayFont = 'Cairo';
  static const String uiFont = 'IBMPlexSansArabic';
}
"@

Write-DartFile "lib/core/design_system/dimensions.dart" @"
class GmailooDimensions {
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double maxContentWidth = 540.0;
}
"@

Write-DartFile "lib/core/design_system/components/gmailoo_app_bar.dart" @"
import 'package:flutter/material.dart';

class GmailooAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  const GmailooAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: title);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
"@

Write-DartFile "lib/core/design_system/components/gmailoo_button.dart" @"
import 'package:flutter/material.dart';

class GmailooButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const GmailooButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: child);
  }
}
"@

Write-DartFile "lib/core/design_system/components/gmailoo_chip.dart" @"
import 'package:flutter/material.dart';

class GmailooChip extends StatelessWidget {
  final String label;
  final Color? color;
  const GmailooChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label), backgroundColor: color);
  }
}
"@

Write-DartFile "lib/core/design_system/components/zen_indicator.dart" @"
import 'package:flutter/material.dart';

class ZenIndicator extends StatelessWidget {
  const ZenIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.spa, color: Colors.green);
  }
}
"@

Write-DartFile "lib/core/utils/text_direction_helper.dart" @"
import 'dart:ui' show TextDirection;

class TextDirectionHelper {
  static TextDirection directionOf(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final firstRtl = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return firstRtl.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }
}
"@

Write-DartFile "lib/core/utils/safe_logger.dart" @"
class SafeLogger {
  static void log(String message) {
    // Redact emails / PII
    final sanitized = message.replaceAll(RegExp(r'[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+'), '[REDACTED_EMAIL]');
    // ignore: avoid_print
    print(sanitized);
  }
}
"@

# Localization
Write-DartFile "lib/l10n/l10n.dart" @"
import 'package:flutter/material.dart';

class L10n {
  static const supportedLocales = [
    Locale('ar', 'EG'),
    Locale('en', 'US'),
  ];
}
"@

Write-DartFile "lib/l10n/app_en.arb" @"
{
  \"@@locale\": \"en\",
  \"appName\": \"Gmailoo\",
  \"importantUnread\": \"Important unread\",
  \"important\": \"Important\",
  \"timetables\": \"Timetables\",
  \"marketing\": \"Marketing\",
  \"everythingElse\": \"Everything else\",
  \"zenDay\": \"Zen Day\"
}
"@

Write-DartFile "lib/l10n/app_ar.arb" @"
{
  \"@@locale\": \"ar\",
  \"appName\": \"جيميلو\",
  \"importantUnread\": \"مهم غير مقروء\",
  \"important\": \"مهم\",
  \"timetables\": \"الجداول والمواعيد\",
  \"marketing\": \"العروض الترويجية\",
  \"everythingElse\": \"باقي الرسائل\",
  \"zenDay\": \"يوم الهدوء (Zen Day)\"
}
"@

Write-Output "Core & App files generated."
