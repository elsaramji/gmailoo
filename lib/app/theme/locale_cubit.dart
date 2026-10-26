// lib/app/theme/locale_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit({Locale initialLocale = const Locale('ar', 'EG')})
      : super(initialLocale);

  void setLocale(Locale locale) => emit(locale);

  void switchToArabic() => emit(const Locale('ar', 'EG'));

  void switchToEnglish() => emit(const Locale('en', 'US'));

  void toggleLocale() {
    if (state.languageCode == 'ar') {
      emit(const Locale('en', 'US'));
    } else {
      emit(const Locale('ar', 'EG'));
    }
  }
}
