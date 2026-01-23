import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';

const String _languageKey = 'selected_language';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      return Locale(savedLanguage);
    }
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = locale;
    await prefs.setString(_languageKey, locale.languageCode);
  }

  Future<void> toggleLanguage() async {
    if (state.languageCode == 'en') {
      await setLocale(const Locale('ne'));
    } else {
      await setLocale(const Locale('en'));
    }
  }

  bool get isEnglish => state.languageCode == 'en';
  bool get isNepali => state.languageCode == 'ne';
}
