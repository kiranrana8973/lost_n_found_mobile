# Lost & Found Mobile Application

## Complete Technical Documentation

---

# Table of Contents

1. [Project Overview](#1-project-overview)
2. [Clean Architecture](#2-clean-architecture)
3. [Project Structure](#3-project-structure)
4. [Hive Database](#4-hive-database)
5. [Dio API Client](#5-dio-api-client)
6. [Features](#6-features)
7. [State Management](#7-state-management)
8. [Data Models](#8-data-models)
9. [Application Flow](#9-application-flow)
10. [API Endpoints](#10-api-endpoints)
11. [Dependencies](#11-dependencies)

---

# 1. Project Overview

## 1.1 Introduction

The **Lost & Found Mobile Application** is a Flutter-based mobile application designed to help users report and discover lost or found items within a community or organization. The app follows modern software development practices including Clean Architecture, offline-first design, and reactive state management.

## 1.2 Key Features

| Feature | Description |
|---------|-------------|
| **User Authentication** | Secure login and registration with JWT token-based authentication |
| **Report Lost Items** | Users can report items they have lost with photos/videos |
| **Report Found Items** | Users can report items they have found |
| **Search & Filter** | Full-text search and category-based filtering |
| **Media Upload** | Support for photo and video uploads |
| **Offline Support** | Local caching with Hive database for offline access |
| **Claim Items** | Users can claim items that belong to them |
| **User Profiles** | Personal profiles with batch/group association |

## 1.3 Technology Stack

| Component | Technology |
|-----------|------------|
| **Framework** | Flutter 3.x |
| **Language** | Dart |
| **State Management** | Riverpod |
| **Local Database** | Hive |
| **HTTP Client** | Dio |
| **Architecture** | Clean Architecture |

---

# 2. Clean Architecture

## 2.1 Overview

Clean Architecture is a software design philosophy that separates the codebase into distinct layers, each with specific responsibilities. This separation ensures:

- **Testability**: Each layer can be tested independently
- **Maintainability**: Changes in one layer don't affect others
- **Scalability**: Easy to add new features without modifying existing code
- **Independence**: Business logic is independent of UI and external frameworks

## 2.2 Architecture Layers

The application is divided into three main layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  (Pages, Widgets, ViewModels, State Management)             │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  (Entities, Repository Interfaces, Use Cases)               │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  (Models, Data Sources, Repository Implementations)         │
└─────────────────────────────────────────────────────────────┘
```

### 2.2.1 Presentation Layer

**Purpose**: Handles all UI-related concerns and user interactions.

**Components**:
- **Pages/Screens**: Full-page widgets (LoginPage, DashboardPage, etc.)
- **Widgets**: Reusable UI components (ItemCard, SearchBar, etc.)
- **ViewModels**: State management classes using Riverpod NotifierProvider
- **State Classes**: Immutable state objects with status tracking

**Example**:
```dart
// ViewModel Example
class ItemViewModel extends Notifier<ItemState> {
  @override
  ItemState build() => ItemState();

  Future<void> getAllItems() async {
    state = state.copyWith(status: ItemStatus.loading);
    final result = await _getAllItemsUsecase.call();
    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        items: items,
      ),
    );
  }
}
```

### 2.2.2 Domain Layer

**Purpose**: Contains business logic and is independent of any external frameworks.

**Components**:
- **Entities**: Pure business objects representing core data
- **Repository Interfaces**: Abstract contracts defining data operations
- **Use Cases**: Single-responsibility classes executing business logic

**Example**:
```dart
// Entity
class ItemEntity extends Equatable {
  final String? id;
  final String? itemName;
  final String? description;
  final String? type; // 'lost' or 'found'
  final String? location;
  // ... other properties
}

// Repository Interface
abstract class IItemRepository {
  Future<Either<Failure, List<ItemEntity>>> getAllItems();
  Future<Either<Failure, ItemEntity>> createItem(ItemEntity item);
  // ... other methods
}

// Use Case
class GetAllItemsUsecase {
  final IItemRepository repository;

  Future<Either<Failure, List<ItemEntity>>> call() {
    return repository.getAllItems();
  }
}
```

### 2.2.3 Data Layer

**Purpose**: Handles data retrieval and storage from various sources.

**Components**:
- **Models**: Data transfer objects with serialization logic
  - API Models: `fromJson()` / `toJson()` for API communication
  - Hive Models: `@HiveType` annotated classes for local storage
- **Data Sources**:
  - Remote: API calls using Dio
  - Local: Hive database operations
- **Repository Implementations**: Concrete implementations of domain interfaces

**Example**:
```dart
// Repository Implementation
class ItemRepository implements IItemRepository {
  final ApiClient _apiClient;
  final HiveService _hiveService;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    if (await _networkInfo.isConnected) {
      // Fetch from API
      final response = await _apiClient.get(ApiEndpoints.items);
      final items = (response.data as List)
          .map((json) => ItemApiModel.fromJson(json).toEntity())
          .toList();
      // Cache locally
      await _hiveService.cacheItems(items);
      return Right(items);
    } else {
      // Return cached data
      final cachedItems = await _hiveService.getAllItems();
      return Right(cachedItems);
    }
  }
}
```

## 2.3 Data Flow Diagram

```
┌──────────┐    ┌───────────┐    ┌─────────┐    ┌────────────┐    ┌─────────────┐
│   UI     │───>│ ViewModel │───>│ UseCase │───>│ Repository │───>│ DataSource  │
│ (Page)   │    │  (State)  │    │         │    │            │    │ (API/Hive)  │
└──────────┘    └───────────┘    └─────────┘    └────────────┘    └─────────────┘
     ^                                                                    │
     │                                                                    │
     └────────────────────────────────────────────────────────────────────┘
                              (Response flows back)
```

---

# 3. Project Structure

## 3.1 Directory Layout

```
lib/
├── app/                              # Application Configuration
│   ├── app.dart                      # Main App widget
│   ├── routes/                       # Navigation routing
│   │   └── app_routes.dart
│   └── theme/                        # Theme configuration
│       └── app_theme.dart
│
├── core/                             # Core Functionality (Shared)
│   ├── api/                          # HTTP Client
│   │   ├── api_client.dart           # Dio client setup
│   │   ├── api_endpoints.dart        # API URL constants
│   │   └── interceptors/             # Request/Response interceptors
│   │       ├── auth_interceptor.dart
│   │       └── retry_interceptor.dart
│   │
│   ├── constants/                    # App-wide constants
│   │   └── app_constants.dart
│   │
│   ├── error/                        # Error handling
│   │   ├── exceptions.dart           # Custom exceptions
│   │   └── failures.dart             # Failure classes
│   │
│   ├── services/                     # Core Services
│   │   ├── connectivity/             # Network detection
│   │   │   └── network_info.dart
│   │   ├── hive/                     # Local database
│   │   │   └── hive_service.dart
│   │   ├── media/                    # Media handling
│   │   │   └── media_service.dart
│   │   └── storage/                  # Secure storage
│   │       ├── token_service.dart
│   │       └── user_session_service.dart
│   │
│   ├── usecases/                     # Base use case class
│   │   └── usecase.dart
│   │
│   ├── utils/                        # Utility functions
│   │   └── validators.dart
│   │
│   └── widgets/                      # Reusable widgets
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── loading_widget.dart
│
└── features/                         # Feature Modules
    ├── auth/                         # Authentication Feature
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   │   ├── auth_api_model.dart
    │   │   │   └── auth_hive_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── auth_entity.dart
    │   │   ├── repositories/
    │   │   │   └── i_auth_repository.dart
    │   │   └── usecases/
    │   │       ├── login_usecase.dart
    │   │       └── register_usecase.dart
    │   └── presentation/
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── signup_page.dart
    │       ├── viewmodel/
    │       │   ├── auth_state.dart
    │       │   └── auth_viewmodel.dart
    │       └── widgets/
    │
    ├── batch/                        # Batch Management Feature
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── category/                     # Category Feature
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    ├── dashboard/                    # Dashboard Feature
    │   └── presentation/
    │       └── pages/
    │           ├── dashboard_page.dart
    │           ├── home_screen.dart
    │           ├── found_screen.dart
    │           ├── lost_screen.dart
    │           └── profile_screen.dart
    │
    ├── item/                         # Item Management Feature
    │   ├── data/
    │   │   ├── models/
    │   │   │   ├── item_api_model.dart
    │   │   │   └── item_hive_model.dart
    │   │   └── repositories/
    │   │       └── item_repository.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── item_entity.dart
    │   │   ├── repositories/
    │   │   │   └── i_item_repository.dart
    │   │   └── usecases/
    │   │       ├── create_item_usecase.dart
    │   │       ├── get_all_items_usecase.dart
    │   │       └── upload_photo_usecase.dart
    │   └── presentation/
    │       ├── pages/
    │       │   ├── item_detail_page.dart
    │       │   ├── my_items_page.dart
    │       │   └── report_item_page.dart
    │       ├── viewmodel/
    │       │   ├── item_state.dart
    │       │   └── item_viewmodel.dart
    │       └── widgets/
    │           └── item_card.dart
    │
    ├── onboarding/                   # Onboarding Feature
    │   └── presentation/
    │
    └── splash/                       # Splash Screen Feature
        └── presentation/
            └── pages/
                └── splash_page.dart
```

---

# 4. Hive Database

## 4.1 Introduction to Hive

Hive is a lightweight and blazing-fast key-value database written in pure Dart. It is used in this application for:

- **Offline Support**: Caching API responses for offline access
- **Local Storage**: Storing user data locally
- **Performance**: Fast read/write operations
- **Type Safety**: Strongly typed data models with adapters

## 4.2 Database Configuration

### 4.2.1 Initialization

The Hive database is initialized in `main.dart` before the app starts:

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveService.instance.init();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 4.2.2 HiveService Implementation

The `HiveService` is a singleton class managing all Hive operations:

```dart
class HiveService {
  static final HiveService _instance = HiveService._internal();
  static HiveService get instance => _instance;

  HiveService._internal();

  // Box references
  late Box<BatchHiveModel> _batchBox;
  late Box<AuthHiveModel> _studentBox;
  late Box<ItemHiveModel> _itemBox;
  late Box<CategoryHiveModel> _categoryBox;

  // Initialization
  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register adapters
    _registerAdapters();

    // Open boxes
    await _openBoxes();
  }

  void _registerAdapters() {
    Hive.registerAdapter(BatchHiveModelAdapter());    // TypeId: 0
    Hive.registerAdapter(AuthHiveModelAdapter());     // TypeId: 1
    Hive.registerAdapter(ItemHiveModelAdapter());     // TypeId: 2
    Hive.registerAdapter(CategoryHiveModelAdapter()); // TypeId: 3
  }

  Future<void> _openBoxes() async {
    _batchBox = await Hive.openBox<BatchHiveModel>('batch_table');
    _studentBox = await Hive.openBox<AuthHiveModel>('student_table');
    _itemBox = await Hive.openBox<ItemHiveModel>('item_table');
    _categoryBox = await Hive.openBox<CategoryHiveModel>('category_table');
  }
}
```

## 4.3 Hive Models

### 4.3.1 Model Overview

| Model | Type ID | Box Name | Purpose |
|-------|---------|----------|---------|
| `BatchHiveModel` | 0 | batch_table | Store batch/group information |
| `AuthHiveModel` | 1 | student_table | Store user/student data |
| `ItemHiveModel` | 2 | item_table | Store lost/found items |
| `CategoryHiveModel` | 3 | category_table | Store item categories |

### 4.3.2 BatchHiveModel

```dart
import 'package:hive/hive.dart';

part 'batch_hive_model.g.dart';

@HiveType(typeId: 0)
class BatchHiveModel extends HiveObject {
  @HiveField(0)
  final String? batchId;

  @HiveField(1)
  final String? batchName;

  @HiveField(2)
  final String? status;

  BatchHiveModel({
    this.batchId,
    this.batchName,
    this.status,
  });

  // Convert to Entity
  BatchEntity toEntity() {
    return BatchEntity(
      id: batchId,
      batchName: batchName,
      status: status,
    );
  }

  // Create from Entity
  factory BatchHiveModel.fromEntity(BatchEntity entity) {
    return BatchHiveModel(
      batchId: entity.id,
      batchName: entity.batchName,
      status: entity.status,
    );
  }
}
```

### 4.3.3 AuthHiveModel

```dart
@HiveType(typeId: 1)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String? fullName;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final String? phoneNumber;

  @HiveField(4)
  final String? username;

  @HiveField(5)
  final String? password;

  @HiveField(6)
  final String? batchId;

  @HiveField(7)
  final String? profilePicture;

  AuthHiveModel({
    this.authId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.username,
    this.password,
    this.batchId,
    this.profilePicture,
  });

  AuthEntity toEntity() {
    return AuthEntity(
      id: authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      batchId: batchId,
      profilePicture: profilePicture,
    );
  }
}
```

### 4.3.4 ItemHiveModel

```dart
@HiveType(typeId: 2)
class ItemHiveModel extends HiveObject {
  @HiveField(0)
  final String? itemId;

  @HiveField(1)
  final String? reportedBy;

  @HiveField(2)
  final String? claimedBy;

  @HiveField(3)
  final String? category;

  @HiveField(4)
  final String? itemName;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String? type;  // 'lost' or 'found'

  @HiveField(7)
  final String? location;

  @HiveField(8)
  final String? media;

  @HiveField(9)
  final String? mediaType;  // 'photo' or 'video'

  @HiveField(10)
  final bool? isClaimed;

  @HiveField(11)
  final String? status;

  ItemHiveModel({
    this.itemId,
    this.reportedBy,
    this.claimedBy,
    this.category,
    this.itemName,
    this.description,
    this.type,
    this.location,
    this.media,
    this.mediaType,
    this.isClaimed,
    this.status,
  });
}
```

### 4.3.5 CategoryHiveModel

```dart
@HiveType(typeId: 3)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String? categoryId;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? status;

  CategoryHiveModel({
    this.categoryId,
    this.name,
    this.description,
    this.status,
  });
}
```

## 4.4 Hive Operations

### 4.4.1 CRUD Operations

```dart
// HiveService CRUD Methods

// CREATE
Future<void> createItem(ItemHiveModel item) async {
  await _itemBox.put(item.itemId, item);
}

// READ - Get All
Future<List<ItemEntity>> getAllItems() async {
  return _itemBox.values.map((model) => model.toEntity()).toList();
}

// READ - Get by ID
Future<ItemEntity?> getItemById(String id) async {
  final model = _itemBox.get(id);
  return model?.toEntity();
}

// READ - Get by User
Future<List<ItemEntity>> getItemsByUser(String userId) async {
  return _itemBox.values
      .where((item) => item.reportedBy == userId)
      .map((model) => model.toEntity())
      .toList();
}

// READ - Get by Type
Future<List<ItemEntity>> getItemsByType(String type) async {
  return _itemBox.values
      .where((item) => item.type == type)
      .map((model) => model.toEntity())
      .toList();
}

// UPDATE
Future<void> updateItem(ItemHiveModel item) async {
  await _itemBox.put(item.itemId, item);
}

// DELETE
Future<void> deleteItem(String id) async {
  await _itemBox.delete(id);
}

// DELETE ALL
Future<void> clearAllItems() async {
  await _itemBox.clear();
}
```

### 4.4.2 Caching API Responses

```dart
// Cache items from API response
Future<void> cacheItems(List<ItemEntity> items) async {
  await _itemBox.clear();
  for (final item in items) {
    final hiveModel = ItemHiveModel.fromEntity(item);
    await _itemBox.put(hiveModel.itemId, hiveModel);
  }
}

// Cache batches from API response
Future<void> cacheBatches(List<BatchEntity> batches) async {
  await _batchBox.clear();
  for (final batch in batches) {
    final hiveModel = BatchHiveModel.fromEntity(batch);
    await _batchBox.put(hiveModel.batchId, hiveModel);
  }
}
```

## 4.5 Code Generation

Hive uses code generation for type adapters. After defining models:

1. Add `part` directive to model file:
   ```dart
   part 'item_hive_model.g.dart';
   ```

2. Run build_runner:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Generated adapter file contains serialization logic.

---

# 5. Dio API Client

## 5.1 Introduction to Dio

Dio is a powerful HTTP client for Dart that supports:
- Global configuration
- Interceptors
- Request/Response transformation
- File uploading/downloading
- Timeout handling
- Error handling

## 5.2 API Client Configuration

### 5.2.1 Base Configuration

```dart
// api_client.dart
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Auth Interceptor
    _dio.interceptors.add(AuthInterceptor());

    // Retry Interceptor
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        retries: 3,
        retryDelays: [
          const Duration(seconds: 1),
          const Duration(seconds: 2),
          const Duration(seconds: 3),
        ],
      ),
    );

    // Logger (Debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }
}
```

### 5.2.2 API Endpoints Configuration

```dart
// api_endpoints.dart
class ApiEndpoints {
  // Base URLs
  static const String serverUrl = 'http://localhost:3000';
  static const String baseUrl = '$serverUrl/api/v1';

  // For Android Emulator (use 10.0.2.2 instead of localhost)
  static String get androidBaseUrl =>
      'http://10.0.2.2:3000/api/v1';

  // Auth Endpoints
  static const String login = '/students/login';
  static const String register = '/students';
  static String student(String id) => '/students/$id';

  // Item Endpoints
  static const String items = '/items';
  static String item(String id) => '/items/$id';
  static String claimItem(String id) => '/items/$id/claim';

  // Media Endpoints
  static const String uploadPhoto = '/items/upload-photo';
  static const String uploadVideo = '/items/upload-video';

  // Category Endpoints
  static const String categories = '/categories';
  static String category(String id) => '/categories/$id';

  // Batch Endpoints
  static const String batches = '/batches';
  static String batch(String id) => '/batches/$id';

  // Comment Endpoints
  static const String comments = '/comments';
  static String comment(String id) => '/comments/$id';
  static String itemComments(String itemId) => '/comments/item/$itemId';

  // Media URLs
  static String profilePicture(String filename) =>
      '$serverUrl/profile_pictures/$filename';
  static String itemPhoto(String filename) =>
      '$serverUrl/item_photos/$filename';
  static String itemVideo(String filename) =>
      '$serverUrl/item_videos/$filename';
}
```

## 5.3 Interceptors

### 5.3.1 Authentication Interceptor

The Auth Interceptor automatically adds JWT tokens to requests:

```dart
// auth_interceptor.dart
class AuthInterceptor extends Interceptor {
  final TokenService _tokenService = TokenService();

  // Public endpoints that don't need authentication
  final List<String> _publicEndpoints = [
    '/batches',
    '/categories',
    '/students/login',
    '/students',  // POST only (register)
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if endpoint is public
    final isPublic = _publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (!isPublic) {
      // Add authorization header
      final token = await _tokenService.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid
      await _tokenService.removeToken();
      // Navigate to login (handled in UI layer)
    }
    handler.next(err);
  }
}
```

### 5.3.2 Retry Interceptor

Automatically retries failed requests due to network issues:

```dart
// Using dio_smart_retry package
RetryInterceptor(
  dio: dio,
  logPrint: print,
  retries: 3,
  retryDelays: const [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 3),
  ],
  retryEvaluator: (error, attempt) {
    // Only retry on connection errors, not 4xx/5xx
    return error.type == DioExceptionType.connectionError ||
           error.type == DioExceptionType.connectionTimeout;
  },
)
```

## 5.4 HTTP Methods

### 5.4.1 GET Request

```dart
Future<Response> get(
  String endpoint, {
  Map<String, dynamic>? queryParameters,
}) async {
  try {
    final response = await _dio.get(
      endpoint,
      queryParameters: queryParameters,
    );
    return response;
  } on DioException catch (e) {
    throw _handleError(e);
  }
}

// Usage Example
final response = await apiClient.get(ApiEndpoints.items);
final items = (response.data as List)
    .map((json) => ItemApiModel.fromJson(json))
    .toList();
```

### 5.4.2 POST Request

```dart
Future<Response> post(
  String endpoint, {
  dynamic data,
  Map<String, dynamic>? queryParameters,
}) async {
  try {
    final response = await _dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
    );
    return response;
  } on DioException catch (e) {
    throw _handleError(e);
  }
}

// Usage Example
final response = await apiClient.post(
  ApiEndpoints.items,
  data: {
    'itemName': 'Lost Wallet',
    'description': 'Black leather wallet',
    'type': 'lost',
    'location': 'Library',
    'category': 'categoryId123',
  },
);
```

### 5.4.3 PUT Request

```dart
Future<Response> put(
  String endpoint, {
  dynamic data,
}) async {
  try {
    final response = await _dio.put(
      endpoint,
      data: data,
    );
    return response;
  } on DioException catch (e) {
    throw _handleError(e);
  }
}

// Usage Example
await apiClient.put(
  ApiEndpoints.item('itemId123'),
  data: {'isClaimed': true},
);
```

### 5.4.4 DELETE Request

```dart
Future<Response> delete(String endpoint) async {
  try {
    final response = await _dio.delete(endpoint);
    return response;
  } on DioException catch (e) {
    throw _handleError(e);
  }
}

// Usage Example
await apiClient.delete(ApiEndpoints.item('itemId123'));
```

### 5.4.5 File Upload

```dart
Future<Response> uploadFile(
  String endpoint, {
  required File file,
  required String fieldName,
  Map<String, dynamic>? additionalFields,
}) async {
  try {
    final fileName = file.path.split('/').last;
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      ...?additionalFields,
    });

    final response = await _dio.post(
      endpoint,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
    return response;
  } on DioException catch (e) {
    throw _handleError(e);
  }
}

// Usage Example
final response = await apiClient.uploadFile(
  ApiEndpoints.uploadPhoto,
  file: imageFile,
  fieldName: 'photo',
  additionalFields: {'itemId': 'itemId123'},
);
final photoUrl = response.data['filename'];
```

## 5.5 Error Handling

```dart
Exception _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return TimeoutException('Connection timed out');

    case DioExceptionType.connectionError:
      return NetworkException('No internet connection');

    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode;
      final message = error.response?.data['message'] ?? 'Unknown error';

      switch (statusCode) {
        case 400:
          return BadRequestException(message);
        case 401:
          return UnauthorizedException('Please login again');
        case 403:
          return ForbiddenException('Access denied');
        case 404:
          return NotFoundException('Resource not found');
        case 500:
          return ServerException('Server error');
        default:
          return ApiException(message);
      }

    default:
      return ApiException('Something went wrong');
  }
}
```

---

# 6. Features

## 6.1 Authentication Feature

### 6.1.1 Overview

The authentication feature handles user registration, login, and session management.

### 6.1.2 Components

**Screens:**
- `LoginPage`: Email/password login with validation
- `SignupPage`: User registration with batch selection

**Use Cases:**
- `LoginUsecase`: Authenticates user credentials
- `RegisterUsecase`: Creates new user account
- `GetCurrentUserUsecase`: Retrieves logged-in user
- `LogoutUsecase`: Clears session and token

**Flow:**
```
Login Flow:
User enters credentials → Validate input →
API call to /students/login → Receive JWT token →
Save token (TokenService) → Save user session (UserSessionService) →
Navigate to Dashboard

Registration Flow:
User fills form → Select batch → Validate input →
API call to POST /students → Auto-login →
Navigate to Dashboard
```

### 6.1.3 Session Management

```dart
// UserSessionService
class UserSessionService {
  final SharedPreferences _prefs;

  Future<void> saveUserSession(AuthEntity user) async {
    await _prefs.setString('userId', user.id ?? '');
    await _prefs.setString('fullName', user.fullName ?? '');
    await _prefs.setString('email', user.email ?? '');
    await _prefs.setString('username', user.username ?? '');
    await _prefs.setString('batchId', user.batchId ?? '');
    await _prefs.setString('profilePicture', user.profilePicture ?? '');
  }

  Future<bool> isLoggedIn() async {
    final userId = _prefs.getString('userId');
    return userId != null && userId.isNotEmpty;
  }

  Future<void> clearSession() async {
    await _prefs.clear();
  }
}

// TokenService
class TokenService {
  static const String _tokenKey = 'jwt_token';
  final SharedPreferences _prefs;

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }
}
```

## 6.2 Item Management Feature

### 6.2.1 Overview

The core feature for reporting and discovering lost/found items.

### 6.2.2 Components

**Screens:**
- `ReportItemPage`: Form to report lost/found items
- `ItemDetailPage`: View full item details
- `MyItemsPage`: User's reported items

**Use Cases:**
- `GetAllItemsUsecase`: Fetch all items
- `GetItemsByUserUsecase`: Fetch user's items
- `GetLostItemsUsecase`: Fetch only lost items
- `GetFoundItemsUsecase`: Fetch only found items
- `CreateItemUsecase`: Report new item
- `UpdateItemUsecase`: Update item details
- `DeleteItemUsecase`: Remove item
- `ClaimItemUsecase`: Claim an item
- `UploadPhotoUsecase`: Upload item photo
- `UploadVideoUsecase`: Upload item video

### 6.2.3 Report Item Flow

```
1. User taps FAB on Dashboard
2. Navigate to ReportItemPage
3. Select item type (Lost/Found)
4. Fill form:
   - Item name
   - Description
   - Category (dropdown)
   - Location
5. Optionally add photo/video
6. Submit form
7. API creates item
8. Navigate back to Dashboard
9. Item appears in list
```

### 6.2.4 Item Entity

```dart
class ItemEntity extends Equatable {
  final String? id;
  final String? itemName;
  final String? description;
  final String? type;        // 'lost' or 'found'
  final String? location;
  final String? category;
  final String? reportedBy;
  final String? claimedBy;
  final String? media;
  final String? mediaType;   // 'photo' or 'video'
  final bool? isClaimed;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Reporter details (populated from API)
  final AuthEntity? reporter;
  final CategoryEntity? categoryDetails;

  const ItemEntity({
    this.id,
    this.itemName,
    this.description,
    this.type,
    this.location,
    this.category,
    this.reportedBy,
    this.claimedBy,
    this.media,
    this.mediaType,
    this.isClaimed,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.reporter,
    this.categoryDetails,
  });
}
```

## 6.3 Dashboard Feature

### 6.3.1 Overview

The main navigation hub with bottom navigation and floating action button.

### 6.3.2 Structure

```dart
class DashboardPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(),      // Index 0 - Browse items
          MyItemsPage(),     // Index 1 - User's items
          AlertsScreen(),    // Index 2 - Notifications
          ProfileScreen(),   // Index 3 - User profile
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Items'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ReportItemPage()),
        ),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
```

### 6.3.3 Home Screen Features

- **Search Bar**: Full-text search on items
- **Statistics**: Count of lost/found items
- **Filter Tabs**: All / Lost / Found
- **Item Grid/List**: Display items with cards
- **Pull to Refresh**: Refresh item list

## 6.4 Category Feature

### 6.4.1 Overview

Manages item categories for better organization.

### 6.4.2 Available Categories (Examples)

| Category | Description |
|----------|-------------|
| Electronics | Phones, laptops, chargers |
| Documents | IDs, cards, certificates |
| Accessories | Watches, jewelry, bags |
| Clothing | Jackets, shoes, hats |
| Books | Textbooks, notebooks |
| Keys | Car keys, house keys |
| Others | Miscellaneous items |

## 6.5 Batch Feature

### 6.5.1 Overview

Manages user groups/batches for organizational purposes (e.g., class batches, department groups).

### 6.5.2 Usage

- Users select their batch during registration
- Items can be filtered by batch
- Helps in community-specific lost & found

---

# 7. State Management

## 7.1 Riverpod Overview

The application uses **Riverpod** for state management, specifically:
- `NotifierProvider` for stateful logic
- State classes for immutable state representation
- `ref.watch()` and `ref.read()` for state access

## 7.2 State Pattern

### 7.2.1 State Class Structure

```dart
enum ItemStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
}

class ItemState extends Equatable {
  final ItemStatus status;
  final List<ItemEntity> items;
  final List<ItemEntity> myItems;
  final List<ItemEntity> lostItems;
  final List<ItemEntity> foundItems;
  final ItemEntity? selectedItem;
  final String? errorMessage;
  final String? uploadedPhotoUrl;
  final String? uploadedVideoUrl;

  const ItemState({
    this.status = ItemStatus.initial,
    this.items = const [],
    this.myItems = const [],
    this.lostItems = const [],
    this.foundItems = const [],
    this.selectedItem,
    this.errorMessage,
    this.uploadedPhotoUrl,
    this.uploadedVideoUrl,
  });

  ItemState copyWith({
    ItemStatus? status,
    List<ItemEntity>? items,
    List<ItemEntity>? myItems,
    String? errorMessage,
    String? uploadedPhotoUrl,
  }) {
    return ItemState(
      status: status ?? this.status,
      items: items ?? this.items,
      myItems: myItems ?? this.myItems,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedPhotoUrl: uploadedPhotoUrl ?? this.uploadedPhotoUrl,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    myItems,
    selectedItem,
    errorMessage,
  ];
}
```

### 7.2.2 ViewModel Structure

```dart
// Provider definition
final itemViewModelProvider = NotifierProvider<ItemViewModel, ItemState>(
  () => ItemViewModel(),
);

// ViewModel implementation
class ItemViewModel extends Notifier<ItemState> {
  late final GetAllItemsUsecase _getAllItemsUsecase;
  late final CreateItemUsecase _createItemUsecase;
  late final UploadPhotoUsecase _uploadPhotoUsecase;

  @override
  ItemState build() {
    // Initialize dependencies
    _getAllItemsUsecase = ref.read(getAllItemsUsecaseProvider);
    _createItemUsecase = ref.read(createItemUsecaseProvider);
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    return const ItemState();
  }

  Future<void> getAllItems() async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _getAllItemsUsecase.call();

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemStatus.loaded,
        items: items,
        lostItems: items.where((i) => i.type == 'lost').toList(),
        foundItems: items.where((i) => i.type == 'found').toList(),
      ),
    );
  }

  Future<void> createItem(ItemEntity item) async {
    state = state.copyWith(status: ItemStatus.loading);

    final result = await _createItemUsecase.call(item);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (createdItem) {
        final updatedItems = [...state.items, createdItem];
        state = state.copyWith(
          status: ItemStatus.created,
          items: updatedItems,
        );
      },
    );
  }

  Future<void> uploadPhoto(File file) async {
    final result = await _uploadPhotoUsecase.call(file);

    result.fold(
      (failure) => state = state.copyWith(
        status: ItemStatus.error,
        errorMessage: failure.message,
      ),
      (photoUrl) => state = state.copyWith(
        uploadedPhotoUrl: photoUrl,
      ),
    );
  }
}
```

## 7.3 Using State in UI

```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemViewModelProvider);

    // Handle different states
    return switch (itemState.status) {
      ItemStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      ItemStatus.error => Center(
        child: Text(itemState.errorMessage ?? 'Error occurred'),
      ),
      ItemStatus.loaded => ListView.builder(
        itemCount: itemState.items.length,
        itemBuilder: (context, index) {
          final item = itemState.items[index];
          return ItemCard(item: item);
        },
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

// Triggering actions
class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch items on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itemViewModelProvider.notifier).getAllItems();
    });
  }
}
```

---

# 8. Data Models

## 8.1 Model Conversion Pattern

Each feature has two model types that convert to/from entities:

```
┌─────────────┐         ┌──────────┐         ┌─────────────┐
│  API Model  │ ──────> │  Entity  │ <────── │ Hive Model  │
│  (Remote)   │         │ (Domain) │         │  (Local)    │
└─────────────┘         └──────────┘         └─────────────┘
   fromJson()            Pure Dart            toEntity()
   toJson()              Object               fromEntity()
   toEntity()
```

## 8.2 API Models

### 8.2.1 ItemApiModel

```dart
class ItemApiModel {
  final String? id;
  final String? itemName;
  final String? description;
  final String? type;
  final String? location;
  final String? category;
  final String? reportedBy;
  final String? claimedBy;
  final String? media;
  final String? mediaType;
  final bool? isClaimed;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  // Nested objects from API
  final AuthApiModel? reportedByUser;
  final CategoryApiModel? categoryDetails;

  ItemApiModel({
    this.id,
    this.itemName,
    this.description,
    this.type,
    this.location,
    this.category,
    this.reportedBy,
    this.claimedBy,
    this.media,
    this.mediaType,
    this.isClaimed,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.reportedByUser,
    this.categoryDetails,
  });

  factory ItemApiModel.fromJson(Map<String, dynamic> json) {
    return ItemApiModel(
      id: json['_id'] ?? json['id'],
      itemName: json['itemName'],
      description: json['description'],
      type: json['type'],
      location: json['location'],
      category: json['category'] is String
          ? json['category']
          : json['category']?['_id'],
      reportedBy: json['reportedBy'] is String
          ? json['reportedBy']
          : json['reportedBy']?['_id'],
      claimedBy: json['claimedBy'],
      media: json['media'],
      mediaType: json['mediaType'],
      isClaimed: json['isClaimed'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      reportedByUser: json['reportedBy'] is Map
          ? AuthApiModel.fromJson(json['reportedBy'])
          : null,
      categoryDetails: json['category'] is Map
          ? CategoryApiModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'description': description,
      'type': type,
      'location': location,
      'category': category,
      'reportedBy': reportedBy,
      'media': media,
      'mediaType': mediaType,
    };
  }

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      itemName: itemName,
      description: description,
      type: type,
      location: location,
      category: category,
      reportedBy: reportedBy,
      claimedBy: claimedBy,
      media: media,
      mediaType: mediaType,
      isClaimed: isClaimed,
      status: status,
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      reporter: reportedByUser?.toEntity(),
      categoryDetails: categoryDetails?.toEntity(),
    );
  }

  static List<ItemEntity> toEntityList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ItemApiModel.fromJson(json).toEntity())
        .toList();
  }
}
```

### 8.2.2 AuthApiModel

```dart
class AuthApiModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? username;
  final String? password;
  final String? batchId;
  final String? profilePicture;
  final BatchApiModel? batch;

  AuthApiModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.username,
    this.password,
    this.batchId,
    this.profilePicture,
    this.batch,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      username: json['username'],
      batchId: json['batch'] is String
          ? json['batch']
          : json['batch']?['_id'],
      profilePicture: json['profilePicture'],
      batch: json['batch'] is Map
          ? BatchApiModel.fromJson(json['batch'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'username': username,
      'password': password,
      'batch': batchId,
    };
  }

  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      batchId: batchId,
      profilePicture: profilePicture,
      batch: batch?.toEntity(),
    );
  }
}
```

---

# 9. Application Flow

## 9.1 App Startup Flow

```
┌─────────────────────────────────────────────────────────────┐
│                        main.dart                             │
│  1. WidgetsFlutterBinding.ensureInitialized()               │
│  2. HiveService.instance.init()                             │
│  3. SharedPreferences.getInstance()                         │
│  4. runApp(ProviderScope(...))                              │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       SplashPage                             │
│  1. Show animated logo                                       │
│  2. Check if user is logged in (UserSessionService)         │
│  3. Wait 3 seconds                                           │
│  4. Navigate based on login status                          │
└─────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              │                               │
              ▼                               ▼
┌─────────────────────┐         ┌─────────────────────┐
│   If Not Logged In  │         │   If Logged In      │
│   → LoginPage       │         │   → DashboardPage   │
└─────────────────────┘         └─────────────────────┘
```

## 9.2 Authentication Flow

### 9.2.1 Login Flow

```
User                    App                     API                  Local Storage
  │                      │                       │                        │
  │  Enter credentials   │                       │                        │
  │─────────────────────>│                       │                        │
  │                      │                       │                        │
  │                      │  POST /students/login │                        │
  │                      │──────────────────────>│                        │
  │                      │                       │                        │
  │                      │  { token, user }      │                        │
  │                      │<──────────────────────│                        │
  │                      │                       │                        │
  │                      │  Save token           │                        │
  │                      │───────────────────────────────────────────────>│
  │                      │                       │                        │
  │                      │  Save user session    │                        │
  │                      │───────────────────────────────────────────────>│
  │                      │                       │                        │
  │  Navigate to Dashboard                       │                        │
  │<─────────────────────│                       │                        │
```

### 9.2.2 Registration Flow

```
User                    App                     API                  Hive
  │                      │                       │                     │
  │  Fill registration   │                       │                     │
  │  form + select batch │                       │                     │
  │─────────────────────>│                       │                     │
  │                      │                       │                     │
  │                      │  POST /students       │                     │
  │                      │──────────────────────>│                     │
  │                      │                       │                     │
  │                      │  { user }             │                     │
  │                      │<──────────────────────│                     │
  │                      │                       │                     │
  │                      │  Cache user locally   │                     │
  │                      │────────────────────────────────────────────>│
  │                      │                       │                     │
  │                      │  Auto-login           │                     │
  │                      │──────────────────────>│                     │
  │                      │                       │                     │
  │  Navigate to Dashboard                       │                     │
  │<─────────────────────│                       │                     │
```

## 9.3 Item Management Flow

### 9.3.1 View Items Flow

```
┌─────────────┐     ┌──────────────┐     ┌────────────┐     ┌───────────┐
│  HomeScreen │────>│ ItemViewModel│────>│ Repository │────>│ API/Hive  │
│  initState()│     │ getAllItems()│     │ getAllItems│     │           │
└─────────────┘     └──────────────┘     └────────────┘     └───────────┘
                           │                    │                  │
                           │                    │   Check Network  │
                           │                    │<─────────────────│
                           │                    │                  │
                           │         ┌──────────┴──────────┐       │
                           │         │                     │       │
                           │    [Online]              [Offline]    │
                           │         │                     │       │
                           │         ▼                     ▼       │
                           │    GET /items           Hive.getAll() │
                           │         │                     │       │
                           │         │  Cache to Hive      │       │
                           │         │─────────────────────│       │
                           │                    │                  │
                           │<───────────────────│                  │
                    Update State               │                  │
                    (ItemStatus.loaded)        │                  │
                           │                    │                  │
┌─────────────┐            │                    │                  │
│  Rebuild UI │<───────────│                    │                  │
│  with items │                                                    │
└─────────────┘
```

### 9.3.2 Report Item Flow

```
User                    ReportItemPage              ItemViewModel           API
  │                          │                           │                   │
  │  Fill item form          │                           │                   │
  │─────────────────────────>│                           │                   │
  │                          │                           │                   │
  │  Select photo            │                           │                   │
  │─────────────────────────>│                           │                   │
  │                          │                           │                   │
  │                          │  uploadPhoto(file)        │                   │
  │                          │──────────────────────────>│                   │
  │                          │                           │                   │
  │                          │                           │  POST /upload     │
  │                          │                           │──────────────────>│
  │                          │                           │                   │
  │                          │                           │  { filename }     │
  │                          │                           │<──────────────────│
  │                          │                           │                   │
  │                          │  photoUrl                 │                   │
  │                          │<──────────────────────────│                   │
  │                          │                           │                   │
  │  Submit form             │                           │                   │
  │─────────────────────────>│                           │                   │
  │                          │                           │                   │
  │                          │  createItem(entity)       │                   │
  │                          │──────────────────────────>│                   │
  │                          │                           │                   │
  │                          │                           │  POST /items      │
  │                          │                           │──────────────────>│
  │                          │                           │                   │
  │                          │                           │  { item }         │
  │                          │                           │<──────────────────│
  │                          │                           │                   │
  │                          │  ItemStatus.created       │                   │
  │                          │<──────────────────────────│                   │
  │                          │                           │                   │
  │  Navigate back           │                           │                   │
  │<─────────────────────────│                           │                   │
```

## 9.4 Offline Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     Network Available                        │
├─────────────────────────────────────────────────────────────┤
│  1. Fetch from API                                          │
│  2. Transform API Model → Entity                            │
│  3. Cache Entity → Hive Model → Hive Box                    │
│  4. Return Entity to UI                                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   Network Unavailable                        │
├─────────────────────────────────────────────────────────────┤
│  1. Read from Hive Box                                      │
│  2. Transform Hive Model → Entity                           │
│  3. Return Entity to UI                                     │
│  4. Show offline indicator (optional)                       │
└─────────────────────────────────────────────────────────────┘
```

---

# 10. API Endpoints

## 10.1 Base Configuration

| Setting | Value |
|---------|-------|
| Base URL | `http://localhost:3000/api/v1` |
| Content-Type | `application/json` |
| Authentication | Bearer Token (JWT) |

## 10.2 Authentication Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/students` | Register new user | No |
| POST | `/students/login` | Login user | No |
| GET | `/students/{id}` | Get user by ID | Yes |

### Request/Response Examples

**Login Request:**
```json
POST /api/v1/students/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Login Response:**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "userId123",
    "fullName": "John Doe",
    "email": "user@example.com",
    "username": "johndoe",
    "batch": {
      "_id": "batchId123",
      "batchName": "Batch 2024"
    }
  }
}
```

## 10.3 Item Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/items` | Get all items | Yes |
| GET | `/items/{id}` | Get item by ID | Yes |
| POST | `/items` | Create new item | Yes |
| PUT | `/items/{id}` | Update item | Yes |
| DELETE | `/items/{id}` | Delete item | Yes |
| POST | `/items/{id}/claim` | Claim item | Yes |

### Request/Response Examples

**Create Item Request:**
```json
POST /api/v1/items
{
  "itemName": "Black Wallet",
  "description": "Leather wallet with initials JD",
  "type": "lost",
  "location": "Library, 2nd Floor",
  "category": "categoryId123",
  "media": "wallet_photo.jpg",
  "mediaType": "photo"
}
```

**Get Items Response:**
```json
{
  "success": true,
  "data": [
    {
      "_id": "itemId123",
      "itemName": "Black Wallet",
      "description": "Leather wallet with initials JD",
      "type": "lost",
      "location": "Library, 2nd Floor",
      "category": {
        "_id": "categoryId123",
        "name": "Accessories"
      },
      "reportedBy": {
        "_id": "userId123",
        "fullName": "John Doe",
        "email": "user@example.com"
      },
      "media": "wallet_photo.jpg",
      "mediaType": "photo",
      "isClaimed": false,
      "status": "active",
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

## 10.4 Media Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/items/upload-photo` | Upload item photo | Yes |
| POST | `/items/upload-video` | Upload item video | Yes |

### Upload Request

```
POST /api/v1/items/upload-photo
Content-Type: multipart/form-data

photo: [binary file data]
```

### Upload Response

```json
{
  "success": true,
  "filename": "1705312200000_wallet_photo.jpg"
}
```

## 10.5 Category Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/categories` | Get all categories | No |
| GET | `/categories/{id}` | Get category by ID | No |

## 10.6 Batch Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/batches` | Get all batches | No |
| GET | `/batches/{id}` | Get batch by ID | No |

## 10.7 Media URLs

| Resource | URL Pattern |
|----------|-------------|
| Profile Pictures | `http://localhost:3000/profile_pictures/{filename}` |
| Item Photos | `http://localhost:3000/item_photos/{filename}` |
| Item Videos | `http://localhost:3000/item_videos/{filename}` |

---

# 11. Dependencies

## 11.1 Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^3.0.3

  # Local Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Networking
  dio: ^5.4.1
  dio_smart_retry: ^7.0.1
  pretty_dio_logger: ^1.4.0
  connectivity_plus: ^7.0.0

  # Storage
  flutter_secure_storage: ^10.0.0
  shared_preferences: ^2.5.4
  path_provider: ^2.1.2

  # Media
  image_picker: ^1.0.7
  cached_network_image: ^3.4.1
  flutter_svg: ^2.0.10+1

  # Functional Programming
  dartz: ^0.10.1
  equatable: ^2.0.7

  # Utilities
  uuid: ^4.3.3
  intl: ^0.19.0
```

## 11.2 Dev Dependencies

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter

  # Code Generation
  build_runner: ^2.4.8
  hive_generator: ^2.0.1

  # Linting
  flutter_lints: ^5.0.0
```

## 11.3 Dependency Purposes

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management with providers |
| `hive` / `hive_flutter` | Local NoSQL database |
| `dio` | HTTP client for API calls |
| `dio_smart_retry` | Automatic retry on failures |
| `pretty_dio_logger` | Debug logging for API calls |
| `connectivity_plus` | Network connectivity detection |
| `flutter_secure_storage` | Secure token storage |
| `shared_preferences` | Simple key-value storage |
| `path_provider` | Access to device directories |
| `image_picker` | Camera/gallery image selection |
| `cached_network_image` | Image caching and loading |
| `dartz` | Functional programming (Either type) |
| `equatable` | Value equality for classes |
| `uuid` | Generate unique IDs |

---

# Summary

The **Lost & Found Mobile Application** is a well-architected Flutter application that demonstrates modern software development practices:

1. **Clean Architecture** ensures separation of concerns and maintainability
2. **Hive Database** provides fast, offline-capable local storage
3. **Dio HTTP Client** handles all API communication with retry and auth support
4. **Riverpod State Management** offers reactive and testable state handling
5. **Feature-First Structure** organizes code by business domain

The application successfully enables users to:
- Report lost or found items with photos/videos
- Search and discover items in their community
- Claim items that belong to them
- Work offline with cached data
- Securely authenticate and manage their profile

---

**Document Version:** 1.0
**Last Updated:** January 2025
**Project:** Lost & Found Mobile Application
