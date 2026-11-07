import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State notifier for application localization (en / ne).
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  void setLocale(Locale locale) {
    if (state != locale) {
      state = locale;
    }
  }

  void toggleLocale() {
    state = state.languageCode == 'en' ? const Locale('ne') : const Locale('en');
  }

  bool get isNepali => state.languageCode == 'ne';
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
