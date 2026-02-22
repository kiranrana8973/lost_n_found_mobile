# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

```bash
flutter pub get                    # Install dependencies
flutter run                        # Run on connected device/emulator
flutter build apk --debug          # Build debug APK
flutter build apk --release        # Build release APK
flutter analyze                    # Static analysis (uses flutter_lints)
dart run build_runner build         # Generate code (Hive models, JSON serialization)
dart run build_runner build --delete-conflicting-outputs  # Force regenerate
```

No test suite exists yet (no `test/` directory).

## Architecture

**Clean Architecture** with three layers per feature, using **Riverpod** for state management and **GoRouter** for navigation.

### Layer Flow (data direction)

```
UI (pages/widgets) → ViewModel (Notifier) → UseCase → Repository Interface → Repository Impl → DataSource (local/remote)
```

- **Domain layer** defines entities and repository interfaces. Use cases contain business logic and return `Either<Failure, T>` (from `dartz`).
- **Data layer** implements repositories. Each has a local datasource (Hive) and remote datasource (Dio). The repository checks connectivity to decide which to use.
- **Presentation layer** uses `ConsumerStatefulWidget`/`ConsumerWidget` with `ref.watch()` for reactive UI.

### Feature Module Pattern

Every feature under `lib/features/` follows this exact structure:
```
features/{name}/
├── data/
│   ├── datasources/local/    # Hive operations
│   ├── datasources/remote/   # API calls via ApiClient
│   ├── models/               # *_hive_model.dart, *_api_model.dart
│   └── repositories/         # Implements domain interface
├── domain/
│   ├── entities/             # Pure Dart classes
│   ├── repositories/         # Abstract interface (IAuthRepository, etc.)
│   └── usecases/             # Single-responsibility use case classes
└── presentation/
    ├── pages/                # Full screens
    ├── widgets/              # Feature-specific widgets
    ├── state/                # State classes (Equatable, with copyWith)
    └── view_model/           # Riverpod Notifier<State>
```

### Navigation Architecture

GoRouter redirect in `app_router.dart` is the **single navigation authority**. The splash page is pure UI with zero navigation logic. Navigation decisions flow like:

1. `AuthViewModel.build()` fires `_hydrateAuthState()` via `Future.microtask()`
2. `RouterNotifier` listens to auth state changes and has an `isReady` gate (auth resolved + 2s splash timer)
3. Router redirect decides: not ready → splash, authenticated → dashboard, unauthenticated → onboarding (first time) or login (returning)

Onboarding completion is persisted in SharedPreferences (`hasSeenOnboarding`) and survives logout.

### Auth & Token Flow

Two storage systems:
- **FlutterSecureStorage** — access/refresh tokens for API auth (managed by `ApiClient._TokenManager`)
- **SharedPreferences** — user session data (`UserSessionService`) and flags

Login saves to both. Logout clears both (except onboarding flag). On cold start, `_hydrateAuthState()` reads from local storage (no network call) to restore session instantly.

The `_AuthInterceptor` in `ApiClient` automatically:
- Adds Bearer token to non-public requests
- Refreshes token on 401 responses
- Triggers `ApiClient.onTokenExpired` callback on refresh failure (which logs out user)

### State Management Conventions

- `NotifierProvider<ViewModel, State>` for mutable feature state
- `Provider` for singletons (ApiClient, Router, services)
- State classes extend `Equatable` with a `copyWith` method
- `AuthStatus` enum: `initial` → `loading` → `authenticated`/`unauthenticated`/`registered`/`error`

## Key Configuration

### API Base URL

Configured in `lib/core/api/api_endpoints.dart`:
- Emulator: `http://10.0.2.2:3000/api/v1` (Android), `http://localhost:3000/api/v1` (iOS/Web)
- Physical device: Set `isPhysicalDevice = true` and update `_ipAddress`

### Hive Tables

Defined in `lib/core/constants/hive_table_constant.dart`. Type IDs (0-4) must be unique and never change once assigned.

### Android Build

- AGP 8.9.1, Kotlin 2.1.0, Gradle 8.11.1 (in `android/settings.gradle.kts` and `gradle-wrapper.properties`)
- App ID: `com.kiran.lost_n_found.lost_n_found`

### Localization

Two languages: English (`en`) and Nepali (`ne`). Strings defined in `lib/core/localization/app_localizations.dart` as static maps. Toggle via `localeProvider`.

## Error Handling Pattern

```dart
// Domain: Use cases return Either<Failure, T>
final result = await _loginUsecase(LoginParams(...));
result.fold(
  (failure) => state = state.copyWith(status: AuthStatus.error, errorMessage: failure.message),
  (user) => state = state.copyWith(status: AuthStatus.authenticated, user: user),
);
```

Three failure types: `ApiFailure` (with statusCode), `LocalDatabaseFailure`, `NetworkFailure`.

## Routes

Public: `/` (splash), `/onboarding`, `/login`, `/signup`
Protected: `/dashboard`, `/report-item`, `/item/:id`, `/batches`

Route constants in `lib/app/routes/route_constants.dart`. Navigation extensions on BuildContext in `router_extensions.dart`.
