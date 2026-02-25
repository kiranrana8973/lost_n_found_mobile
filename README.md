# Lost & Found - Softwarica College

A mobile application for reporting and finding lost items within Softwarica College campus. Built with Flutter using Clean Architecture, Riverpod state management, and offline-first capabilities.

## Features

- Report lost or found items with photos/videos
- Browse and search items by category, type, or user
- User authentication with JWT (login, register, profile)
- Offline support with Hive local caching
- Real-time data sync when online
- Bilingual support (English / Nepali)
- Dark mode support

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.10+ |
| State Management | Riverpod |
| Navigation | GoRouter |
| Local Storage | Hive |
| Networking | Dio |
| Auth Tokens | FlutterSecureStorage |
| Error Handling | dartz (Either pattern) |
| Testing | flutter_test, mocktail |

## Architecture

Clean Architecture with three layers per feature:

```
UI (Pages/Widgets) → ViewModel (Notifier) → UseCase → Repository Interface → Repository Impl → DataSource (Local/Remote)
```

### Project Structure

```
lib/
├── app/
│   ├── routes/          # GoRouter configuration
│   └── theme/           # App theme, colors, extensions
├── core/
│   ├── api/             # ApiClient (Dio), endpoints
│   ├── constants/       # App & Hive constants
│   ├── error/           # Failures, exceptions
│   ├── extensions/      # BuildContext extensions
│   ├── localization/    # EN/NE translations
│   ├── services/        # Hive, connectivity, auth, storage
│   ├── usecases/        # Base usecase interfaces
│   ├── utils/           # Snackbar utilities
│   └── widgets/         # Shared widgets
├── features/
│   ├── auth/            # Login, register, profile
│   ├── batch/           # College batches
│   ├── category/        # Item categories
│   ├── dashboard/       # Home, item listing
│   ├── item/            # Report/browse items
│   ├── onboarding/      # First-time walkthrough
│   └── splash/          # Splash screen
└── main.dart
```

Each feature follows:

```
features/{name}/
├── data/
│   ├── datasources/local/    # Hive (owns its own HiveBox<T>)
│   ├── datasources/remote/   # API calls
│   ├── models/               # Hive & API models
│   └── repositories/         # Online/offline logic
├── domain/
│   ├── entities/
│   ├── repositories/         # Abstract interface
│   └── usecases/
└── presentation/
    ├── pages/
    ├── widgets/
    ├── state/
    └── view_model/           # Riverpod Notifier
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.10.0
- Dart SDK
- Android Studio / VS Code
- Backend server running (Node.js API)

### Setup

```bash
# Clone the repo
git clone https://github.com/your-username/lost_n_found_mobile.git
cd lost_n_found_mobile

# Install dependencies
flutter pub get

# Generate Hive adapters & JSON serialization
dart run build_runner build --delete-conflicting-outputs

# Run on connected device/emulator
flutter run
```

### API Configuration

Edit `lib/core/api/api_endpoints.dart`:

```dart
static const bool isPhysicalDevice = false;    // true for physical device
static const String _ipAddress = '192.168.1.1'; // your machine's IP
static const int _port = 3000;
```

- Android Emulator: auto-resolves to `10.0.2.2`
- iOS Simulator / Web: uses `localhost`
- Physical Device: set `isPhysicalDevice = true` and update `_ipAddress`

## Build

```bash
flutter build apk --debug      # Debug APK
flutter build apk --release    # Release APK
```

## Testing

252 tests across 44 test files covering entities, usecases, repositories, models, and widgets.

```bash
flutter test                   # Run all tests
flutter test --coverage        # With coverage report
```

## Android Build Config

| Config | Value |
|--------|-------|
| Package Name | `com.kiran.lost_n_found.lost_n_found` |
| AGP | 8.9.1 |
| Kotlin | 2.1.0 |
| Gradle | 8.11.1 |
| Java | 17 |
