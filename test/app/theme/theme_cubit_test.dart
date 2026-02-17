import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/app/theme/theme_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ThemeCubit themeCubit;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  tearDown(() {
    themeCubit.close();
  });

  group('initial state', () {
    test('starts with ThemeMode.system when no saved preference', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn(null);

      themeCubit = ThemeCubit(prefs: mockPrefs);

      expect(themeCubit.state, ThemeMode.system);
    });

    test('starts with ThemeMode.dark when saved as dark', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn('dark');

      themeCubit = ThemeCubit(prefs: mockPrefs);

      expect(themeCubit.state, ThemeMode.dark);
    });

    test('starts with ThemeMode.light when saved as light', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn('light');

      themeCubit = ThemeCubit(prefs: mockPrefs);

      expect(themeCubit.state, ThemeMode.light);
    });
  });

  group('setThemeMode', () {
    blocTest<ThemeCubit, ThemeMode>(
      'emits dark mode and saves to prefs',
      setUp: () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn(null);
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
      },
      build: () => ThemeCubit(prefs: mockPrefs),
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [ThemeMode.dark],
      verify: (_) {
        verify(() => mockPrefs.setString('theme_mode', 'dark')).called(1);
      },
    );

    blocTest<ThemeCubit, ThemeMode>(
      'emits light mode and saves to prefs',
      setUp: () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn(null);
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
      },
      build: () => ThemeCubit(prefs: mockPrefs),
      act: (cubit) => cubit.setThemeMode(ThemeMode.light),
      expect: () => [ThemeMode.light],
      verify: (_) {
        verify(() => mockPrefs.setString('theme_mode', 'light')).called(1);
      },
    );
  });

  group('toggleTheme', () {
    blocTest<ThemeCubit, ThemeMode>(
      'toggles from dark to light',
      setUp: () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn('dark');
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
      },
      build: () => ThemeCubit(prefs: mockPrefs),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.light],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'toggles from light to dark',
      setUp: () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn('light');
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
      },
      build: () => ThemeCubit(prefs: mockPrefs),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );

    blocTest<ThemeCubit, ThemeMode>(
      'toggles from system to dark',
      setUp: () {
        when(() => mockPrefs.getString('theme_mode')).thenReturn(null);
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
      },
      build: () => ThemeCubit(prefs: mockPrefs),
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [ThemeMode.dark],
    );
  });

  group('isDarkMode', () {
    test('returns true when state is dark', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn('dark');

      themeCubit = ThemeCubit(prefs: mockPrefs);

      expect(themeCubit.isDarkMode, true);
    });

    test('returns false when state is light', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn('light');

      themeCubit = ThemeCubit(prefs: mockPrefs);

      expect(themeCubit.isDarkMode, false);
    });

    test('returns false when state is system', () {
      when(() => mockPrefs.getString('theme_mode')).thenReturn(null);

      themeCubit = ThemeCubit(prefs: mockPrefs);

      expect(themeCubit.isDarkMode, false);
    });
  });
}
