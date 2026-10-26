// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../l10n/l10n.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/locale_cubit.dart';
import 'theme/theme_cubit.dart';

class GmailooApp extends StatelessWidget {
  const GmailooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
      ],
      child: ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeMode = context.watch<ThemeCubit>().state;
          final locale = context.watch<LocaleCubit>().state;

          return MaterialApp.router(
            title: 'Gmailoo',
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.buildTheme(
              brightness: Brightness.light,
              locale: locale,
            ),
            darkTheme: AppTheme.buildTheme(
              brightness: Brightness.dark,
              locale: locale,
            ),
            themeMode: themeMode,
          );
        },
      ),
    );
  }
}
