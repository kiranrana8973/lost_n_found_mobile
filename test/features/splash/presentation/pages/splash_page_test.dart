import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/splash/presentation/pages/splash_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockUserSessionService mockUserSessionService;
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  setUp(() {
    mockUserSessionService = MockUserSessionService();
    when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
      child: const MaterialApp(home: SplashPage()),
    );
  }

  group('SplashPage - UI Elements', () {
    testWidgets('should display scaffold', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display app title "Lost & Found"', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.text('Lost & Found'), findsOneWidget);
    });

    testWidgets('should display subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(
        find.text('Reuniting people with their belongings'),
        findsOneWidget,
      );
    });

    testWidgets('should display search icon in logo', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    });

    testWidgets('should display loading indicator', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have gradient background container', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display SafeArea', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(SafeArea), findsOneWidget);
    });
  });

  group('SplashPage - Animations', () {
    testWidgets('should have fade animation for title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      // FadeTransition should be present
      expect(find.byType(FadeTransition), findsWidgets);
    });

    testWidgets('should have slide animation for content', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      // SlideTransition should be present
      expect(find.byType(SlideTransition), findsWidgets);
    });

    testWidgets('content should become visible after animation', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Initially pumped
      await tester.pump();

      // After animation delay
      await tester.pump(const Duration(milliseconds: 800));

      // Title should be visible
      expect(find.text('Lost & Found'), findsOneWidget);

      // Complete remaining timers
      await tester.pump(const Duration(seconds: 4));
    });
  });

  group('SplashPage - Navigation', () {
    testWidgets('should check login status', (tester) async {
      // Set larger surface to avoid overflow when navigating to onboarding
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockUserSessionService.isLoggedIn()).called(1);
    });

    testWidgets('should navigate based on login status after delay', (
      tester,
    ) async {
      // Set larger surface to avoid overflow when navigating to onboarding
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      when(() => mockUserSessionService.isLoggedIn()).thenReturn(false);

      await tester.pumpWidget(createTestWidget());

      // Wait for navigation delay (3 seconds)
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));

      // Navigation should have been attempted
      verify(() => mockUserSessionService.isLoggedIn()).called(1);
    });
  });

  group('SplashPage - Responsive Design', () {
    testWidgets('should display logo container', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      // Logo container with gradient
      final logoContainers = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient != null,
      );
      expect(logoContainers, findsWidgets);
    });

    testWidgets('should use FittedBox for title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(FittedBox), findsWidgets);
    });

    testWidgets('should have Column layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should have Spacer for flexible layout', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Spacer), findsWidgets);
    });
  });
}
