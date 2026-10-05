import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/app/app.dart';
import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Open the SQLite database and seed the reference data
  final database = AppDatabase();
  await database.insertBatchDummyData();
  await database.insertCategoryDummyData();

  // Initialize SharedPreferences : because this is async operation
  // but riverpod providers are sync so we need to initialize it here
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const MyApp(),
    ),
  );
}
